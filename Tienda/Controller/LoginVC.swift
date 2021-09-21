//
//  LoginVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase

class LoginVC: UIViewController {

  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passTxt: UITextField!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  override func viewDidLoad() {
        super.viewDidLoad()
    }

  @IBAction func logInButton(_ sender: Any) {
    guard let email = emailTxt.text, email.isNotEmpty, let pass = passTxt.text, pass.isNotEmpty else { return }
    activityIndicator.startAnimating()
    Auth.auth().signIn(withEmail: email, password: pass, completion: { authResult, error in
      if let error = error {
        debugPrint(error.localizedDescription)
        self.activityIndicator.stopAnimating()
      }
      if let user = authResult?.user {
        debugPrint("\(user) logged in correctly")
        self.activityIndicator.stopAnimating()
      }
      
      
    })
  }
  @IBAction func forgotPassword(_ sender: Any) {
  }
  @IBAction func guestButton(_ sender: Any) {
  }
}
