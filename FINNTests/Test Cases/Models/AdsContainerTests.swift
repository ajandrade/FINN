//
//  AdsContainerTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdsContainerTests: XCTestCase {
    
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testIsDecodable() {
    let data = loadJSONData()
    let allAds = try? JSONDecoder().decode(AdsContainer.self, from: data)
    XCTAssertNotNil(allAds)
  }
  
  func testDecodeAdsToNormalAds() {
    let data = loadJSONData()
    let adsList = AdsContainer.decodeAds(from: data)
    XCTAssertGreaterThan(adsList.count, 0)
  }
  
}

extension AdsContainerTests {
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "TestData", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
}
