//
//  AppDelegate.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit
import Firebase
import Stripe

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    StripeAPI.defaultPublishableKey = "pk_test_51JbthIE3LuLqyUPom4BQiSTZUmBpQ9QQpSfUwyiD2aY1tlAzy0cQsFtGW1dJoqdoAJMmHs3SdrRwyM8owkm4OFBd00Wl8D6RPL"
    FirebaseApp.configure()
    
    return true
  }
}

