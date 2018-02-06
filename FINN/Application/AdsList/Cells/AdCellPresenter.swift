//
//  AdCellPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdCellPresenterRepresentable {
  var photoUri: String? { get }
  var price: String { get }
  var location: String { get }
  var adDescription: String { get }
  var isFavourite: Bool { get }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
}

struct AdCellPresenter: AdCellPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider
  private let dependencies: Dependencies

  // MARK: - PROPERTIES
  
  let photoUri: String?
  let price: String
  let location: String
  let adDescription: String
  let isFavourite: Bool
  
  // MARK: - INITIALIZER
  
  init(dependencies: Dependencies, normalAd: NormalAd) {
    self.dependencies = dependencies
    if let adPrice = normalAd.price {
      price = "\(adPrice),-"
    } else {
      price = "Gis bort"
    }
    location = normalAd.location ?? "Unknown location"
    adDescription = normalAd.adDescription ?? "No description"
    isFavourite = normalAd.isFavourite
    photoUri = normalAd.photoUri
  }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    dependencies.network.downloadImage(for: uri) { result in
      switch result {
      case .success(let data):
        completion(.success(data))
      case .failure:
        completion(.failure(NetworkError.noImage))
      }
    }
  }
  
}
