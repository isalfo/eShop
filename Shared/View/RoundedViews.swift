//
//  RoundedViews.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import UIKit

class RoundedButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 5
  }
}

class RoundedShadowView: UIView {
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 10
    layer.shadowColor = AppColors.Blue.cgColor
    layer.shadowOpacity = 0.4
    layer.shadowOffset = CGSize.zero
    layer.shadowRadius = 3
  }
}

class RoundedImageView: UIImageView {
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.cornerRadius = 10
  }
}
