//
//  RegisterVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase
// MARK: RegisterVC class
class RegisterVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet weak var usernameTxt: UITextField!
  @IBOutlet weak var emailTxt: UITextField!
  @IBOutlet weak var passwordTxt: UITextField!
  @IBOutlet weak var confirmPassTxt: UITextField!
  @IBOutlet weak var passCheckImg: UIImageView!
  @IBOutlet weak var confirmPassCheckImg: UIImageView!
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
        super.viewDidLoad()
    
    passwordTxt.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
  
  // MARK: - IBAction methods
  
  @objc func textFieldDidChange(_ textField: UITextField) {
    guard let passText = passwordTxt.text else { return }
    if textField == confirmPassTxt {
      passCheckImg.isHidden = false
      confirmPassCheckImg.isHidden = false
    } else {
      if passText.isEmpty {
        passCheckImg.isHidden = true
        confirmPassCheckImg.isHidden = true
        confirmPassTxt.text = ""
      }
    }
    
    if passwordTxt.text == confirmPassTxt.text {
      passCheckImg.image = UIImage(named: "green_check")
      confirmPassCheckImg.image = UIImage(named: "green_check")
    } else {
      passCheckImg.image = UIImage(named: "red_check")
      confirmPassCheckImg.image = UIImage(named: "red_check")
    }
  }
  
  @IBAction func registerClicked(_ sender: Any) {
    guard let email = emailTxt.text, email.isNotEmpty,
          let password = passwordTxt.text, password.isNotEmpty,
          let username = usernameTxt.text, username.isNotEmpty else { return }
    
    Auth.auth().createUser(withEmail: email, password: password, completion: { _, error in
      
      if let error = error {
        debugPrint(error.localizedDescription)
        return
      }
      
      let alert = UIAlertController(title: "Success", message: "User successfully created", preferredStyle: .alert)
      let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
      
    })
  }
  
}
