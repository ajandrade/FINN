//
//  MockAdsListPresenter.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
@testable import FINN

class MockAdsListPresenter: AdsListPresenterRepresentable {
  
  var numberOfItemsIsCalled = false
  var initialDataIsLoaded = false
  var isPrefetching = false
  var isCancelingPrefetch = false
  var switchDataIsCalled = false
  var setFavouriteIsCalled = false
  
  var didUpdateFavourite: ((Int) -> Void)?

  var numberOfItems: Int {
    numberOfItemsIsCalled = true
    return 1
  }
  
  func item(for index: Int) -> AdCellPresenterRepresentable? {
    let dependencies = DependencyContainer(network: MockNetworkProvider(), fileManager: FileManagerProvider(), database: DatabaseProvider(nil), cache: MockCacheProvider())
    let normalAd = NormalAd(identifier: "123", location: "loc", adDescription: "desc", price: 30, photoUri: "uri", isFavourite: true)
    return AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
  }
  
  func startPrefetching(for indexes: [Int]) {
    isPrefetching = true
  }
  
  func cancelPrefetching(for indexes: [Int]) {
    isCancelingPrefetch = true
  }

  func loadInitialData(_ completion: @escaping (Result<Void, Error>) -> Void) {
    initialDataIsLoaded = true
    completion(.success(()))
  }
  
  func switchData(_ showFavourites: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
    switchDataIsCalled = true
    completion(.success(()))
  }

  func setFavourite(_ isFavourite: Bool, for index: Int) {
    setFavouriteIsCalled = true
  }
  

}
