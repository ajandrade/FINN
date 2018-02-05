//
//  FavouriteAd.swift
//  FINN
//
//  Created by Amadeu Andrade on 05/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
import RealmSwift

class FavouriteAd: Object {
  
  // MARK: - PROPERTIES
  
  @objc dynamic var identifier: String = ""
  @objc dynamic var location: String?
  @objc dynamic var adDescription: String?
  @objc dynamic var price: Double = 0.0
  @objc dynamic var photoUri: String?
  
  override static func primaryKey() -> String? {
    return "identifier"
  }
 
}

extension FavouriteAd {
  
  convenience init(normalAd: NormalAd) {
    self.init()
    identifier = normalAd.identifier
    location = normalAd.location
    adDescription = normalAd.adDescription
    price = normalAd.price ?? 0.0
    photoUri = normalAd.photoUri
  }
  
  func asNormal() -> NormalAd {
    return NormalAd(identifier: identifier, location: location, adDescription: adDescription, price: price, photoUri: photoUri, isFavourite: true)
  }
  
}
