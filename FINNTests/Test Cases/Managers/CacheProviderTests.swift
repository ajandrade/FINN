//
//  CacheProviderTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 09/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class CacheProviderTests: XCTestCase {
  
  var cache: CacheProvider!
  let key = "myKey"
  let data = Data()

  override func setUp() {
    super.setUp()
    cache = CacheProvider()
  }
  
  override func tearDown() {
    super.tearDown()
    cache = nil
  }
  
  func testAddToCache() {
    XCTAssertNil(cache.getData(forkey: key))
    cache.add(data, for: key)
    XCTAssertNotNil(cache.getData(forkey: key))
  }
  
  func testGetDataFromCache() {
    cache.add(data, for: key)
    XCTAssertNotNil(cache.getData(forkey: key))
  }
  
  func testClearCache() {
    cache.add(data, for: key)
    XCTAssertNotNil(cache.getData(forkey: key))
    cache.clearCache()
    XCTAssertNil(cache.getData(forkey: key))
  }
  
}
