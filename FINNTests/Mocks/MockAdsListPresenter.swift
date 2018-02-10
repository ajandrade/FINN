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
  
  var didUpdateFavourite: ((Int) -> Void)?

  var numberOfItems: Int {
    numberOfItemsIsCalled = true
    return 1
  }
  
  func item(for index: Int) -> AdCellPresenterRepresentable? {
    return nil
  }
  
  func startPrefetching(for indexes: [Int]) {}
  
  func cancelPrefetching(for indexes: [Int]) {}

  func loadInitialData(_ completion: @escaping (Result<Void, Error>) -> Void) {}
  
  func switchData(_ showFavourites: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}

  func setFavourite(_ isFavourite: Bool, for index: Int) {}
  

}
