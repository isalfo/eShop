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
  
  var categories = [Category]()
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let category = Category(name: "Lizard", id: "lizardID", imageURL: "https://images.unsplash.com/photo-1632251431418-b4e5fe2410b0?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=900&q=60", isActive: true, timeStamp: Timestamp())
    categories.append(category)
    
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(UINib(nibName: Identifiers.CategoryCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.CategoryCell)
    if Auth.auth().currentUser == nil {
      Auth.auth().signInAnonymously { result, error in
        if let error = error {
          Auth.auth().handleFireAuthError(error: error, vc: self)
        }
      }
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    if let user = Auth.auth().currentUser, !user.isAnonymous {
      logInOutButton.title = "Log Out"
    } else {
      logInOutButton.title = "Log In"
    }
    
  }
  
  // MARK: - Methods
  fileprivate func presentLoginController() {
      let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
      let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
      present(controller, animated: true, completion: nil)
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
    let cellWidth = (width - 50) / 2
    let cellHeight = cellWidth * 1.5
    
    return CGSize(width: cellWidth, height: cellHeight)
  }
}
