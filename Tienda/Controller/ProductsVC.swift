//
//  ProductsVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 22/09/2021.
//

import UIKit
import Firebase

// MARK: ProductsVC class
class ProductsVC: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  var products = [Product]()
  var category: Category!
  var listener: ListenerRegistration?
  var db: Firestore?
  
  // MARK: - Lifecycle methods
  override func viewDidLoad() {
    super.viewDidLoad()
    db = Firestore.firestore()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: Identifiers.ProductCell, bundle: nil), forCellReuseIdentifier: Identifiers.ProductCell)
    setProductsListener()
  }
  
  // MARK: - Methods
  func setProductsListener() {
    listener = db?.products(category: category.id).addSnapshotListener({ snap, error in
      
      if let error = error {
        self.simpleAlert(title: "Error", msg: error.localizedDescription)
      }
      
      snap?.documentChanges.forEach({ change in
        
        let data = change.document.data()
        let product = Product(data: data)
        
        switch change.type {
        case .added:
          self.onDocumentAdded(change: change, product: product)
        case .modified:
          self.onDocumentModified(change: change, product: product)
        case .removed:
          self.onDocumentRemoved(change: change)
          
        }
      })
    })
  }
}

// MARK: - TableView extension
extension ProductsVC: UITableViewDelegate, UITableViewDataSource {
  func onDocumentAdded(change: DocumentChange, product: Product) {
    let newIndex = Int(change.newIndex)
    products.insert(product, at: newIndex)
    tableView.insertRows(at: [IndexPath(item: newIndex, section: 0)], with: .fade)
  }
  
  func onDocumentModified(change: DocumentChange, product: Product) {
    if change.newIndex == change.oldIndex {
      let index = Int(change.newIndex)
      products[index] = product
      tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    } else {
      let oldIndex = Int(change.oldIndex)
      let newIndex = Int(change.newIndex)
      products.remove(at: oldIndex)
      products.insert(product, at: newIndex)
      tableView.moveRow(at: IndexPath(row: oldIndex, section: 0), to: IndexPath(row: newIndex, section: 0))
    }
  }
  
  func onDocumentRemoved(change: DocumentChange){
    let oldIndex = Int(change.oldIndex)
    products.remove(at: oldIndex)
    tableView.deleteRows(at: [IndexPath(item: oldIndex, section: 0)], with: .fade)
  }
  
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = ProductDetailVC()
    let selectedProduct = products[indexPath.row]
    vc.product = selectedProduct
    vc.modalTransitionStyle = .crossDissolve
    vc.modalPresentationStyle = .currentContext
    present(vc, animated: true, completion: nil)
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 200
  }
}
