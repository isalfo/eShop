//
//  ForgotPasswordVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {

  @IBOutlet weak var emailTxt: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    }

  @IBAction func cancelClicked(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func resetPassClicked(_ sender: Any) {
    guard let email = emailTxt.text else {
      simpleAlert(title: "Douh!", msg: "Please provide a valid Email.")
      return
    }
    Auth.auth().sendPasswordReset(withEmail: email) { (error) in
      if let error = error {
        Auth.auth().handleFireAuthError(error: error, vc: self)
      }
      self.dismiss(animated: true, completion: nil)
    }
  }
  
}
