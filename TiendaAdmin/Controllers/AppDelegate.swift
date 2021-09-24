//
//  AppDelegate.swift
//  TiendaAdmin
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    IQKeyboardManager.shared.enable = true
    return true
  }
}
