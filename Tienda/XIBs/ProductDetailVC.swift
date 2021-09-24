//
//  ProductDetailVC.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 23/09/2021.
//

import UIKit

class ProductDetailVC: UIViewController {

  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productDescription: UILabel!
  @IBOutlet weak var productImg: UIImageView!
  @IBOutlet weak var bgView: UIVisualEffectView!
  
  var product: Product?
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    productTitle.text = product?.name
    productDescription.text = product?.productDescription
    if let price = product?.price {
    productPrice.text = "$\(price)0"
    }
    if let url = URL(string: product?.imageURL ?? "") {
      productImg.kf.setImage(with: url)
    }
    
    // TODO: Change local currency, not working on Argentina
//    let formatter = NumberFormatter()
//    formatter.numberStyle = .currency
//    if let price = formatter.string(from: (product?.price ?? 0) as NSNumber) {
//      productPrice.text = price
//    }
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissProd))
    tap.numberOfTapsRequired = 1
    bgView.addGestureRecognizer(tap)
    }

  @objc func dismissProd() {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func addCartClicked(_ sender: Any) {
    // TODO : Add product to cart
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func dismissProduct(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
}

