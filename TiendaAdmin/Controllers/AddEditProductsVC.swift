//
//  AddEditProductsVC.swift
//  TiendaAdmin
//
//  Created by Gonzalo Alfonso on 24/09/2021.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

// MARK: AddEditProductsVC class
class AddEditProductsVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var productNameTxt: UITextField!
  @IBOutlet weak var productPriceTxt: UITextField!
  @IBOutlet weak var productDescTxt: UITextView!
  @IBOutlet weak var productImg: UIImageView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var addProductBtn: UIButton!
  
  var selectedCategory: Category?
  var productToEdit: Product?
  
  var name = ""
  var price = 0.0
  var productDescription = ""
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(imgTapped(_:)))
    tap.numberOfTapsRequired = 1
    productImg.isUserInteractionEnabled = true
    productImg.addGestureRecognizer(tap)
    
    if let product = productToEdit {
      productNameTxt.text = product.name
      productPriceTxt.text = String(product.price)
      productDescTxt.text = product.productDescription
      addProductBtn.setTitle("Save Changes", for: .normal)
      if let url = URL(string: product.imageURL) {
        productImg.contentMode = .scaleAspectFill
        productImg.kf.setImage(with: url)
      }
    }
  }
  
  // MARK: - IBAction and objc methods
  @objc func imgTapped(_ tap: UITapGestureRecognizer) {
    launchImagePicker()
  }
  
  @IBAction func addClicked(_ sender: Any) {
    uploadImageThenDocument()
  }
  
  // MARK: - Methods
  func uploadImageThenDocument() {
    
    guard let image = productImg.image,
          let productName = productNameTxt.text,
          let productDesc = productDescTxt.text, let priceString = productPriceTxt.text, let price = Double(priceString),
          productName.isNotEmpty, productDesc.isNotEmpty else {
      simpleAlert(title: "Forgot something?", msg: "Please add product name, description and image")
      return
    }
    
    self.name = productName
    self.price = price
    self.productDescription = productDesc
    
    activityIndicator.startAnimating()
    
    // See AddEditCategoryVC for step by step explanation
    guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
    
    let imgRef = Storage.storage().reference().child("/productImages/\(productName).jpg")
    
    let metaData = StorageMetadata()
    metaData.contentType = "image/jpg"
    
    imgRef.putData(imageData, metadata: metaData) { metaData, error in
      
      if let error = error {
        self.handleError(error: error)
        return
      }
      
      imgRef.downloadURL { url, error in
        
        if let error = error {
          self.handleError(error: error)
          return
        }
        
        guard let url = url else { return }
        self.activityIndicator.stopAnimating()
        
        self.uploadDocument(url: url.absoluteString)
      }
    }
  }
  
  func uploadDocument(url: String) {
    var docRef: DocumentReference!
    var product = Product(name: self.name, id: "", category: selectedCategory!.id, price: price, productDescription: self.productDescription, imageURL: url, timeStamp: Timestamp(), stock: 0)
    
    if let productToEdit = productToEdit {
      docRef = Firestore.firestore().collection("products").document(productToEdit.id)
      product.id = productToEdit.id
    } else {
      docRef = Firestore.firestore().collection("products").document()
      product.id = docRef.documentID
    }
    
    let data = Product.modelToData(product: product)
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
extension AddEditProductsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func launchImagePicker() {
    let imgPicker = UIImagePickerController()
    imgPicker.delegate = self
    present(imgPicker, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
    productImg.contentMode = .scaleAspectFill
    productImg.image = image
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}
