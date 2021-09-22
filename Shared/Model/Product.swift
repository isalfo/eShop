//
//  Product.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 22/09/2021.
//

import Foundation
import FirebaseFirestore

struct Product {
  var name: String
  var id: String
  var category: String
  var price: Double
  var productDescription: String
  var imageURL: String
  var timeStamp: Timestamp
  var stock: Int
  var favorite: Bool
}
