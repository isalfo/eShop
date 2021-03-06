//
//  ViewController.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase
// MARK: HomeVC Class
class HomeVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var logInOutButton: UIBarButtonItem!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var collectionView: UICollectionView!
  var selectedCategory: Category?
  var db: Firestore?
  var listener: ListenerRegistration?
  
  var categories = [Category]()
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    db = Firestore.firestore()
    setupCollectionView()
    setupInitialAnonymusUser()
    setupNavigationBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    setCategoriesListener()
    
    if let user = Auth.auth().currentUser, !user.isAnonymous {
      logInOutButton.title = "Log Out"
    } else {
      logInOutButton.title = "Log In"
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    listener?.remove()
    categories.removeAll()
    collectionView.reloadData()
  }
  
  // MARK: - Methods
  func setupNavigationBar() {
    guard let font = UIFont(name: "futura", size: 26) else { return }
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
  }
  
  func setupInitialAnonymusUser() {
    if Auth.auth().currentUser == nil {
          Auth.auth().signInAnonymously { result, error in
            if let error = error {
              Auth.auth().handleFireAuthError(error: error, vc: self)
            }
          }
        }
  }
  
  func setupCollectionView() {
        collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
      }
  
  fileprivate func presentLoginController() {
    let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
    present(controller, animated: true, completion: nil)
  }
  
  func setCategoriesListener() {
    listener = db?.categories.addSnapshotListener({ snap, error in
      
      if let error = error {
        self.simpleAlert(title: "Error", msg: error.localizedDescription)
        return
      }
      
      snap?.documentChanges.forEach({ change in
        
        let data = change.document.data()
        let category = Category(data: data)
        
        switch change.type {
        case .added:
          self.onDocumentAdded(change: change, category: category)
        case .modified:
          self.onDocumentModified(change: change, category: category)
        case .removed:
          self.onDocumentRemoved(change: change)
        }
        
      })
      
    })
  }
  
  func onDocumentAdded(change: DocumentChange, category: Category) {
    let newIndex = Int(change.newIndex)
    categories.insert(category, at: newIndex)
    collectionView.insertItems(at: [IndexPath(item: newIndex, section: 0)])
  }
  
  func onDocumentModified(change: DocumentChange, category: Category) {
    if change.newIndex == change.oldIndex {
      let index = Int(change.newIndex)
      categories[index] = category
      collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    } else {
      let oldIndex = Int(change.oldIndex)
      let newIndex = Int(change.newIndex)
      categories.remove(at: oldIndex)
      categories.insert(category, at: newIndex)
      
      collectionView.moveItem(at: IndexPath(item: oldIndex, section: 0), to: IndexPath(item: newIndex, section: 0))
    }
    
  }
  
  func onDocumentRemoved(change: DocumentChange) {
    let oldIndex = Int(change.oldIndex)
    categories.remove(at: oldIndex)
    collectionView.deleteItems(at: [IndexPath(item: oldIndex, section: 0)])
  }
  
  
  
  // MARK: - IBAction methods
  @IBAction func logInOutClicked(_ sender: Any) {
    
    guard let user = Auth.auth().currentUser else { return }
    
    if user.isAnonymous {
      presentLoginController()
    } else {
      do {
        try Auth.auth().signOut()
        presentLoginController()
        Auth.auth().signInAnonymously { result, error in
          if let error = error {
            Auth.auth().handleFireAuthError(error: error, vc: self)
          }
          self.presentLoginController()
        }
      } catch {
        Auth.auth().handleFireAuthError(error: error, vc: self)
      }
    }
  }
}

// MARK: - CollectionView extensions
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CategoryCell, for: indexPath) as? CategoryCell {
      cell.configureCell(category: categories[indexPath.row])
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.frame.width
    let cellWidth = (width - 30) / 2
    let cellHeight = cellWidth * 1.5
    
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    selectedCategory = categories[indexPath.item]
    performSegue(withIdentifier: Segues.ToProduct, sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Segues.ToProduct {
      if let destination = segue.destination as? ProductsVC {
        destination.category = selectedCategory
      }
    }
  }
}

/*
 
 Prior fetching functions
 
 func fetchDocument() {
   let docRef = db?.collection("categories").document("y3BJfc0Vuf87T13DEDSW")
   
   listener = docRef?.addSnapshotListener { snap, error in
     self.categories.removeAll()
     guard let data = snap?.data() else { return }
     let newCategory = Category(data: data)
     self.categories.append(newCategory)
     self.collectionView.reloadData()
   }
 }
 
 func fetchCollection() {
   let collectionRef = db?.collection("categories")
   
   listener = collectionRef?.addSnapshotListener { snap, error in
     guard let documents = snap?.documents else { return }
     self.categories.removeAll()
     for document in documents {
       let data = document.data()
       let newCategory = Category(data: data)
       self.categories.append(newCategory)
     }
     self.collectionView.reloadData()
   }
 }
 */
