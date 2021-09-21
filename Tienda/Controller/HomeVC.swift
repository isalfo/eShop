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
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
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
