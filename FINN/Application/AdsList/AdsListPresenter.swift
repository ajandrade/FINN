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
  
  func setFavourite(_ isFavourite: Bool, for index: Int)
  
}

class AdsListPresenter: AdsListPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider & HasFileManagerProvider & HasDatabaseProvider & HasCacheProvider
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
  
  // MARK: - FAVOURITES
  
  func setFavourite(_ isFavourite: Bool, for index: Int) {
    guard var item = item(for: index) else { return }
    item.isFavourite = isFavourite
    if isFavourite {
      addFavourite(item, index: index)
    } else {
      removeFavourite(item)
    }
  }
  
  private func addFavourite(_ item: AdCellPresenterRepresentable, index: Int) {
    if let imageData = item.cachedData {
      storeImage(data: imageData, with: item.identifier, for: index, { fileUrl in
        self.saveOnDatabase(for: index, photoUrl: fileUrl)
      })
    } else {
      saveOnDatabase(for: index)
    }
  }
  
  private func removeFavourite(_ item: AdCellPresenterRepresentable) {
    dependencies.database.get(by: item.identifier) { result in
      switch result {
      case .success(let ad):
        self.removeImage(item.identifier)
        self.removeFromDatabase(ad)
      case .failure(let err):
        print(err.description)
      }
    }
  }
  
  private func storeImage(data: Data, with identifier: String, for index: Int, _ completion: @escaping (URL) -> Void) {
    dependencies.fileManager.write(data, for: identifier) { result in
      switch result {
      case .success(let fileUrl):
        print(fileUrl)
        self.saveOnDatabase(for: index, photoUrl: fileUrl)
      case .failure(let err):
        print(err)
        self.saveOnDatabase(for: index)
      }
    }
  }
  
  private func saveOnDatabase(for index: Int, photoUrl: URL? = nil) {
    if allData.isEmpty || index > allData.count { return }
    let normalAd = allData[index]
    let favouriteAd = FavouriteAd(normalAd: normalAd)
    dependencies.database.create(favouriteAd) { result in
      switch result {
      case .success:
        print("Created new favourite")
      case .failure(let err):
        print(err.description)
      }
    }
  }
  
  private func removeImage(_ identifier: String) {
    dependencies.fileManager.delete(identifier, { result in
      switch result {
      case .success:
        print("Removed image")
      case .failure(let err):
        print(err.description)
      }
    })
  }
  
  private func removeFromDatabase(_ favouriteAd: FavouriteAd) {
    dependencies.database.delete(favouriteAd, { result in
      switch result {
      case .success:
        print("Removed favourite from DB")
      case .failure(let err):
        print(err.description)
      }
    })
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
