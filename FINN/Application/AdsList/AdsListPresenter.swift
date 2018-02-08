//
//  AdsListPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdsListPresenterRepresentable {
  // CollectionView Data
  var numberOfItems: Int { get }
  func item(for index: Int) -> AdCellPresenterRepresentable? 
  // Prefetch
  func startPrefetching(for indexes: [Int])
  func cancelPrefetching(for indexes: [Int])
  // Data loading
  func loadInitialData(_ completion: @escaping (Result<Void, Error>) -> Void)
  func switchData(_ showFavourites: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
  // Favourites
  func setFavourite(_ isFavourite: Bool, for index: Int)
  var didUpdateFavourite: ((Int) -> Void)? { get set }
}

class AdsListPresenter: AdsListPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider & HasFileManagerProvider & HasDatabaseProvider & HasCacheProvider
  private let dependencies: Dependencies
  
  // MARK: - PRIVATE PROPERTIES
  
  private var allAdsContainer = [NormalAd]()
  private var dataSource = [AdCellPresenterRepresentable]()
  
  // MARK: - PROPERTIES
  
  var numberOfItems: Int {
    return dataSource.count
  }
  
  var didUpdateFavourite: ((Int) -> Void)?
  
  // MARK: - INITIALIZER
  
  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
  
  // MARK: - COLLECTION VIEW DATA
  
  func item(for index: Int) -> AdCellPresenterRepresentable? {
    if dataSource.isEmpty || index > dataSource.count { return nil }
    return dataSource[index]
  }
  
  // MARK: - DATA LOADING
  
  func loadInitialData(_ completion: @escaping (Result<Void, Error>) -> Void) {
    switchData(false, completion)
  }
  
  func switchData(_ showFavourites: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    if showFavourites {
      showFavouritesData(completion)
    } else {
      showInitialData(completion)
    }
  }
  
  private func showFavouritesData(_ completion: @escaping (Result<Void, Error>) -> Void) {
    getAllFavourites { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success(let favourites):
        self.dataSource = []
        favourites.forEach {
          let presenter = AdCellPresenter(dependencies: self.dependencies, normalAd: $0.asNormal())
          self.dataSource.append(presenter)
        }
        completion(.success(()))
      case .failure(let err):
        completion(.failure(err))
      }
    }
  }
  
  private func showInitialData(_ completion: @escaping (Result<Void, Error>) -> Void) {
    getAllFavourites { [weak self] result in
      guard let `self` = self else { return }
      
      let favourites = result.value
      var favouriteAdsIds = [String]()
      favourites?.forEach { favouriteAdsIds.append($0.identifier) }
      
      if self.allAdsContainer.isEmpty {
        // First time in the app OR empty data, make network request
        self.getAllAds { result in
          switch result {
          case .success(let data):
            self.allAdsContainer = AdsContainer.decodeAds(from: data)
            self.setDataSource(matching: favouriteAdsIds)
            completion(.success(()))
          case .failure(let err):
            completion(.failure(err))
          }
        }
      } else {
        // Switching screens, update presenters
        self.setDataSource(matching: favouriteAdsIds)
        completion(.success(()))
      }
    }
  }
  
  private func setDataSource(matching ids: [String]) {
    let newPresenters: [AdCellPresenterRepresentable]
    if ids.isEmpty {
      newPresenters = self.allAdsContainer.map { AdCellPresenter(dependencies: self.dependencies, normalAd: $0) }
    } else {
      newPresenters = self.allAdsContainer.map { normalAd in
        let cellPresenter = AdCellPresenter(dependencies: self.dependencies, normalAd: normalAd)
        cellPresenter.isFavourite = ids.contains(normalAd.identifier) ? true : false
        return cellPresenter
      }
    }
    self.dataSource = newPresenters
  }
  
  private func getAllFavourites(_ completion: @escaping (Result<FavouriteAds, DatabaseError>) -> Void) {
    dependencies.database.getAll { result in
      switch result {
      case .success(let favourites):
        completion(.success(favourites))
      case .failure(let err):
        completion(.failure(err))
      }
    }
  }
  
  private func getAllAds(_ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    dependencies.network.getAds { result in
      switch result {
      case .success(let data):
        completion(.success(data))
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
      removeFavourite(item, index: index)
    }
  }
  
  private func addFavourite(_ item: AdCellPresenterRepresentable, index: Int) {
    if let imageData = item.cachedData {
      storeImage(data: imageData, with: item.identifier, for: index) { [weak self] in
        self?.saveOnDatabase(for: index)
      }
    } else {
      saveOnDatabase(for: index)
    }
  }
  
  private func removeFavourite(_ item: AdCellPresenterRepresentable, index: Int) {
    dependencies.database.get(by: item.identifier) { [weak self] result in
      switch result {
      case .success(let ad):
        self?.removeImage(item.identifier)
        self?.removeFromDatabase(ad, index: index)
      case .failure(let err):
        print(err.description)
      }
    }
  }
  
  private func storeImage(data: Data, with identifier: String, for index: Int, _ completion: @escaping () -> Void) {
    dependencies.fileManager.write(data, for: identifier) { result in
      switch result {
      case .success:
        print("Image saved")
        completion()
      case .failure(let err):
        print(err)
        completion()
      }
    }
  }
  
  private func saveOnDatabase(for index: Int) {
    if allAdsContainer.isEmpty || index > allAdsContainer.count { return }
    let normalAd = allAdsContainer[index]
    let favouriteAd = FavouriteAd(normalAd: normalAd)
    dependencies.database.create(favouriteAd) { [weak self] result in
      switch result {
      case .success:
        print("Created new favourite")
        self?.didUpdateFavourite?(index)
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
  
  private func removeFromDatabase(_ favouriteAd: FavouriteAd, index: Int) {
    dependencies.database.delete(favouriteAd, { [weak self] result in
      switch result {
      case .success:
        print("Removed favourite from DB")
        self?.didUpdateFavourite?(index)
      case .failure(let err):
        print(err.description)
      }
    })
  }
  
  // MARK: - PREFETCH
  
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
