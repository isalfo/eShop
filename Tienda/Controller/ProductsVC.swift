//
//  ProductsVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 22/09/2021.
//

import UIKit
import FirebaseFirestore

class ProductsVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var products = [Product]()
  var category: Category?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let product = Product(name: "Landscape", id: "123", category: "Landscape", price: 25.0, productDescription: "wow", imageURL: "https://media.istockphoto.com/photos/deep-in-the-wild-woods-sunbeams-illuminating-green-forest-panorama-picture-id1292588329?b=1&k=20&m=1292588329&s=170667a&w=0&h=5DT_KIu2TPj7pLD6J2C41Lz3vCj8LcD2dLr79VAFDwE=", timeStamp: Timestamp(), stock: 0, favorite: false)
    products.append(product)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
  }
}

extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.ProductCell, for: indexPath) as? ProductCell {
      
      cell.configureCell(product: products[indexPath.row])
      return cell
    }
    return UITableViewCell()
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
}
