//
//  ViewController.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let storyboard = UIStoryboard(name: Storyboard.LoginStoryboard, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: StoryboardID.LoginVC)
    present(controller, animated: true, completion: nil)
  }
}

