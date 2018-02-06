//
//  AdsListPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdsListPresenterRepresentable {
  var numberOfItems: Int { get }
  
  func item(for index: Int) -> AdCellPresenterRepresentable? 
  
  func getAllAds(_ completion: @escaping (Result<Void, NetworkError>) -> Void)
  
  func startPrefetching(for indexes: [Int])
  func cancelPrefetching(for indexes: [Int])
}

class AdsListPresenter: AdsListPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider & HasImageProvider & HasDatabaseProvider & HasCacheProvider
  private let dependencies: Dependencies
  
  // MARK: - PRIVATE PROPERTIES
  
  private var allData = [NormalAd]()
  private var allDataPresenters = [AdCellPresenterRepresentable]()
  
  // MARK: - OUTPUT PROPERTIES
  
  var numberOfItems: Int {
    return allDataPresenters.count
  }
    
  // MARK: - INITIALIZER
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - FUNCTIONS
  
  func item(for index: Int) -> AdCellPresenterRepresentable? {
    if allDataPresenters.isEmpty || index > allDataPresenters.count { return nil }
    return allDataPresenters[index]
  }
  
  func getAllAds(_ completion: @escaping (Result<Void, NetworkError>) -> Void) {
    dependencies.network.getAds { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success(let data):
        let allAds = AdsContainer.decodeAds(from: data)
        self.allData = allAds
        let cellPresenters = self.allData.map { AdCellPresenter(dependencies: self.dependencies, normalAd: $0) }
        self.allDataPresenters = cellPresenters
        completion(.success(()))
      case .failure(let err):
        completion(.failure(err))
      }
    }
  }
  
  // MARK: - PREFETCHING
  
  func startPrefetching(for indexes: [Int]) {
    let uris = indexes.flatMap { item(for: $0)?.photoUri }
    uris.forEach(downloadImage)
  }
  
  func cancelPrefetching(for indexes: [Int]) {
    let uris = indexes.flatMap { item(for: $0)?.photoUri }
    uris.forEach(cancelTask)
  }
  
  private func downloadImage(_ uri: String) {
    dependencies.network.downloadImage(for: uri) { [weak self] result in
      switch result {
      case .success(let data):
        self?.dependencies.cache.add(data, for: uri)
      default: break
      }
    }
  }
  
  private func cancelTask(_ uri: String) {
    dependencies.network.cancelTask(for: uri)
  }

}
