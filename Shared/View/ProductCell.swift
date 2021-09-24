//
//  ProductCell.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 22/09/2021.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {

  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productImg: RoundedImageView!
  @IBOutlet weak var favoriteBtn: UIButton!
  @IBOutlet weak var productPrice: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()    }
  
  func configureCell(product: Product) {
    productTitle.text = product.name
    productPrice.text = "$\(String(product.price))0"
    
    if let url = URL(string: product.imageURL) {
      let placeholder = UIImage(named: "placeholder")
      let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.5))]
      productImg.kf.indicatorType = .activity
      productImg.kf.setImage(with: url, placeholder: placeholder, options: options)
    }
  }
  
  @IBAction func addToCartClicked(_ sender: Any) {
  }
  @IBAction func favoriteClicked(_ sender: Any) {
  }
  
}
