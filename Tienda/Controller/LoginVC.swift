//
//  LoginVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase
// MARK: LoginVC class
class LoginVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passTxt: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - IBAction methods
  @IBAction func logInButton(_ sender: Any) {
    guard let email = emailTxt.text, email.isNotEmpty, let pass = passTxt.text, pass.isNotEmpty else {
      simpleAlert(title: "Ups!", msg: "Please fill out all fields.")
      return }
    activityIndicator.startAnimating()
    Auth.auth().signIn(withEmail: email, password: pass, completion: { authResult, error in
      if let error = error {
        Auth.auth().handleFireAuthError(error: error, vc: self)
        self.activityIndicator.stopAnimating()
      }
      if let _ = authResult?.user {
        self.activityIndicator.stopAnimating()
        self.dismiss(animated: true, completion: nil)
      }
      
      
    })
  }
  @IBAction func forgotPassword(_ sender: Any) {
    let vc = ForgotPasswordVC()
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .overCurrentContext
    present(vc, animated: true, completion: nil)
  }
  @IBAction func guestButton(_ sender: Any) {
  }
}
