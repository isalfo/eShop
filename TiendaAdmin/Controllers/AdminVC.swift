//
//  ViewController.swift
//  TiendaAdmin
//
//  Created by Gonzalo Alfonso on 20/09/2021.
//

import UIKit

class AdminVC: HomeVC {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.leftBarButtonItem?.isEnabled = false
    let addCategoryBtn = UIBarButtonItem(title: "Add category", style: .plain, target: self, action: #selector(addCategory))
    navigationItem.rightBarButtonItem = addCategoryBtn
    navigationItem.rightBarButtonItem?.tintColor = .white
  }
  
  @objc func addCategory() {
    performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
  }


}

