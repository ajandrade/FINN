//
//  AdsContainer.swift
//  FINN
//
//  Created by Amadeu Andrade on 05/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

struct AdsContainer: Decodable {
  
  // MARK: - PROPERTIES
  
  let items: [NormalAd]
  
  // MARK: - FUNCTIONS
  
  static func decodeAds(from data: Data) -> [NormalAd] {
    let ads = try? JSONDecoder().decode(self, from: data)
    guard let allAds = ads?.items else { return [] }
    return allAds
  }
}
