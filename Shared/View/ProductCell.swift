//
//  ProductCell.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 22/09/2021.
//

import UIKit

class ProductCell: UITableViewCell {

  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productImg: RoundedImageView!
  @IBOutlet weak var favoriteBtn: UIButton!
  @IBOutlet weak var productPrice: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()    }
  
  func configureCell(product: Product) {
    productTitle.text = product.name
    
    if let url = URL(string: product.imageURL) {
      productImg.kf.setImage(with: url)
    }
  }
  
  @IBAction func addToCartClicked(_ sender: Any) {
  }
  @IBAction func favoriteClicked(_ sender: Any) {
  }
  
}
