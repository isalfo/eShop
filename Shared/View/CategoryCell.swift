//
//  CategoryCell.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import UIKit
import Kingfisher

class CategoryCell: UICollectionViewCell {
  
  @IBOutlet weak var categoryImg: UIImageView!
  
  @IBOutlet weak var categoryLbl: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    categoryImg.layer.cornerRadius = 5
  }
  
  func configureCell(category: Category) {
    categoryLbl.text = category.name
    if let url = URL(string: category.imageURL) {
      let placeholder = UIImage(named: "placeholder")
      let options: KingfisherOptionsInfo = [KingfisherOptionsInfoItem.transition(.fade(0.5))]
      categoryImg.kf.indicatorType = .activity
      categoryImg.kf.setImage(with: url, placeholder: placeholder, options: options)
    }
  }
  
}
