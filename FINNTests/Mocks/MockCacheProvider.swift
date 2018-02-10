//
//  MockCacheProvider.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
@testable import FINN

class MockCacheProvider: CacheProviderRepresentable {
  
  var isCached = false
  var getDataIsCalled = false
  
  func add(_ data: Data, for key: String) {
    isCached = true
  }
  
  func getData(forkey key: String) -> Data? {
    getDataIsCalled = true
    return nil
  }

}
