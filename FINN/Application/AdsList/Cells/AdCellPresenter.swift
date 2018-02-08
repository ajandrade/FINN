//
//  AdCellPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdCellPresenterRepresentable {
  var identifier: String { get }
  var photoUri: String? { get }
  var price: String { get }
  var location: String { get }
  var adDescription: String { get }
  var isFavourite: Bool { get set }
  
  var cachedData: Data? { get }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
}

class AdCellPresenter: AdCellPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider & HasCacheProvider
  private let dependencies: Dependencies
  
  // MARK: - PROPERTIES
  
  let identifier: String
  let photoUri: String?
  let price: String
  let location: String
  let adDescription: String
  var isFavourite: Bool
  
  var cachedData: Data? {
    guard let uri = photoUri, let cachedData = dependencies.cache.getData(forkey: uri) else { return nil }
    return cachedData
  }
  
  // MARK: - INITIALIZER
  
  init(dependencies: Dependencies, normalAd: NormalAd) {
    self.dependencies = dependencies
    identifier = normalAd.identifier
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
  
  // MARK: - FUNCTIONS
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    dependencies.network.downloadImage(for: uri) { [weak self] result in
      switch result {
      case .success(let data):
        self?.dependencies.cache.add(data, for: uri)
        completion(.success(data))
      case .failure:
        completion(.failure(NetworkError.noImage))
      }
    }
  }
  
}
