//
//  NormalAd.swift
//  FINN
//
//  Created by Amadeu Andrade on 05/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

struct NormalAd {
  let identifier: String
  let location: String?
  let adDescription: String?
  let price: Double?
  let photoUri: String?
  let isFavourite: Bool
}

extension NormalAd: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case identifier = "id"
    case location
    case price
    case description
    case image
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    identifier = try values.decode(String.self, forKey: .identifier)
    location = try? values.decode(String.self, forKey: .location)
    adDescription = try? values.decode(String.self, forKey: .description)
    let priceValue = try? values.decode(AdPrice.self, forKey: .price)
    price = priceValue?.value
    let imageUri = try? values.decode(AdPhoto.self, forKey: .image)
    photoUri = imageUri?.url
    isFavourite = false
  }
  
}
