//
//  Extensions.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import UIKit
import Firebase

extension String {
  var isNotEmpty: Bool {
    return !isEmpty
  }
}

extension UIViewController {
  func simpleAlert(title: String, msg: String) {
    let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
    present(alert, animated: true, completion: nil)
  }
}
