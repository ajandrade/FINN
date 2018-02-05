//
//  AdCellPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdCellPresenterRepresentable {
  var photoUrl: URL? { get }
  var price: String { get }
  var location: String { get }
  var adDescription: String { get }
  var isFavourite: Bool { get }
}

struct AdCellPresenter: AdCellPresenterRepresentable {
  let photoUrl: URL?
  let price: String
  let location: String
  let adDescription: String
  let isFavourite: Bool
  
  init(ad: NormalAd) {
    if let adPrice = ad.price {
      price = "\(adPrice),-"
    } else {
      price = "Gis bort"
    }
    location = ad.location ?? "Unknown location"
    adDescription = ad.adDescription ?? "No description"
    isFavourite = ad.isFavourite
    photoUrl = nil // TODO: update
  }
}
