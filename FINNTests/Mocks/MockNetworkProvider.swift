//
//  MockNetworkProvider.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit
@testable import FINN

class MockNetworkProvider: NetworkProviderRepresentable {
  
  var getAdsIsCalled = false
  var downloadIsCalled = false
  var cancelIsCalled = false
  
  func getAds(_ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    getAdsIsCalled = true
    let data = loadJSONData()
    completion(.success(data))
  }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    downloadIsCalled = true
    completion(.success(Data()))
  }
  
  func cancelTask(for uri: String) {
    cancelIsCalled = true
  }
  
}

extension MockNetworkProvider {
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "TestData", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
}
