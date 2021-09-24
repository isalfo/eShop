//
//  AddEditCategoryVC.swift
//  TiendaAdmin
//
//  Created by Gonzalo Alfonso on 23/09/2021.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

// MARK: AddEditCategoryVC class
class AddEditCategoryVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var nameTxt: UITextField!
  @IBOutlet weak var categoryImg: RoundedImageView!
  @IBOutlet weak var addBtn: RoundedButton!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  var categoryToEdit: Category?
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
    tap.numberOfTapsRequired = 1
    categoryImg.isUserInteractionEnabled = true
    categoryImg.addGestureRecognizer(tap)
    
    if let category = categoryToEdit {
      nameTxt.text = category.name
      addBtn.setTitle("Save Changes", for: .normal)
      
      if let url = URL(string: category.imageURL) {
        categoryImg.contentMode = .scaleAspectFill
        categoryImg.kf.setImage(with: url)
      }
    }
  }
  
  // MARK: - Objc IBAction methods
  @objc func imgTapped(_ tap: UITapGestureRecognizer) {
    launchImgPicker()
  }
  
  @IBAction func addCategoryClicked(_ sender: Any) {
    uploadImageThenDocument()
  }
  
  // MARK: - Methods
  func uploadImageThenDocument() {
    
    guard let image = categoryImg.image,
          let categoryName = nameTxt.text, categoryName.isNotEmpty else {
      simpleAlert(title: "Forgot something?", msg: "Please add category name and image")
      return
    }
    
    activityIndicator.startAnimating()
    
    // 1. Turn image into data
    guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
    
    // 2. Create a storage image reference, a location in Firestore for it to be stored
    let imgRef = Storage.storage().reference().child("/category/\(categoryName).jpg")
    
    // 3. Create metadata
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    //4. Upload the data
    imgRef.putData(imageData, metadata: metaData) { metaData, error in
      
      if let error = error {
        self.handleError(error: error)
        return
      }
      
      // 5. Once the image is uploaded, retrieve the download URL
      imgRef.downloadURL { url, error in
        
        if let error = error {
          self.handleError(error: error)
          return
        }
        
        guard let url = url else { return }
        self.activityIndicator.stopAnimating()
        
        // 6. Upload new Category document to the Firestore categories collection
        self.uploadDocument(url: url.absoluteString)
      }
    }
  }
  
  func uploadDocument(url: String) {
    var docRef: DocumentReference!
    var category = Category(name: nameTxt.text!, id: "", imageURL: url, timeStamp: Timestamp())
    
    if let categoryToEdit = categoryToEdit {
      docRef = Firestore.firestore().collection("categories").document(categoryToEdit.id)
      category.id = categoryToEdit.id
    } else {
      docRef = Firestore.firestore().collection("categories").document()
      category.id = docRef.documentID
    }
    
    
    
    let data = Category.modelToData(category: category)
    docRef.setData(data, merge: true) { error in
      if let error = error {
        self.handleError(error: error)
        return
      }
      
      self.navigationController?.popViewController(animated: true)
    }
  }
  
  func handleError(error: Error) {
    self.simpleAlert(title: "Error", msg: error.localizedDescription)
    self.activityIndicator.stopAnimating()
  }
}

// MARK: - ImagePicker extension
extension AddEditCategoryVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func launchImgPicker() {
    let imgPicker = UIImagePickerController()
    imgPicker.delegate = self
    present(imgPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
    categoryImg.contentMode = .scaleAspectFill
    categoryImg.image = image
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
