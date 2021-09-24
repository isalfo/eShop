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
      passCheckImg.image = UIImage(named: AppImages.GreenCheck)
      confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
    } else {
      passCheckImg.image = UIImage(named: AppImages.RedCheck)
      confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
    }
  }
  
  @IBAction func registerClicked(_ sender: Any) {
    guard let email = emailTxt.text, email.isNotEmpty,
          let password = passwordTxt.text, password.isNotEmpty,
          let username = usernameTxt.text, username.isNotEmpty else {
      simpleAlert(title: "Ups!", msg: "Please fill out all fields.")
      return }
    
    guard let confirmPass = confirmPassTxt.text, confirmPass == password else {
      simpleAlert(title: "Ups!", msg: "Passwords do not match")
      return
    }
    
    activityIndicator.startAnimating()
    
    guard let authUser = Auth.auth().currentUser else { return }
    
    
    let credential = EmailAuthProvider.credential(withEmail: email, password: password)
    authUser.link(with: credential) { result, error in
      if let error = error {
        Auth.auth().handleFireAuthError(error: error, vc: self)
        self.activityIndicator.stopAnimating()
        return
      }
      
      guard let firUser = result?.user else { return }
      let tiendaUser = User(id: firUser.uid, email: email, username: username, stripeId: "")
      
      self.createFirestoreUser(user: tiendaUser)
      
      let alert = UIAlertController(title: "Success", message: "User successfully created", preferredStyle: .alert)
      let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
        self.dismiss(animated: true, completion: nil)
      })
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
      self.activityIndicator.stopAnimating()
    }
  }
  
  func createFirestoreUser(user: User) {
    let newUserRef = Firestore.firestore().collection("users").document(user.id)
    let data = User.modelToData(user: user)
    
    newUserRef.setData(data) { error in
      if let error = error {
        self.simpleAlert(title: "Error", msg: error.localizedDescription)
      }
    }
    self.activityIndicator.stopAnimating()
  }
}

