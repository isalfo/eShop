//
//  Category.swift
//  Tienda
//
//  Created by Gonzalo Alfonso on 21/09/2021.
//

import Foundation
import FirebaseFirestore

struct Category {
  var name: String
  var id: String
  var imageURL: String
  var isActive: Bool = true
  var timeStamp: Timestamp
}
