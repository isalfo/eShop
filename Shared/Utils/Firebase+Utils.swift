//
//  Firebase+Utils.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import Firebase

extension Firestore {
  var categories: Query {
    return collection("categories").order(by: "timeStamp", descending: true)
  }
  
  func products(category: String) -> Query {
    return collection("products").whereField("category", isEqualTo: category).order(by: "timeStamp", descending: true)
  }
}

extension Auth {
  func handleFireAuthError(error: Error, vc: UIViewController) {
    if let errorCode = AuthErrorCode.init(rawValue: error._code) {
      let alert = UIAlertController(title: "Ups!", message: errorCode.errorMessage, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      vc.present(alert, animated: true, completion: nil)
    }
  }
}

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account. Pick another email!"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Your password is too weak. The password must be 6 characters long or more."
        case .wrongPassword:
            return "Your password or email is incorrect."
            
        default:
            return "Sorry, something went wrong."
        }
    }
}
