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
      categoryImg.kf.setImage(with: url)
    }
  }
  
}
