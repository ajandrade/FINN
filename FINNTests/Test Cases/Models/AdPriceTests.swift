//
//  AdPriceTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdPriceTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testIsDecodable() {
    let data = loadJSONData()
    let price = try? JSONDecoder().decode(AdPrice.self, from: data)
    XCTAssertNotNil(price)
  }
  
  func testPriceValueIsSetOnInit() {
    let price = AdPrice(value: 30)
    XCTAssertEqual(price.value, 30)
  }
  
}

extension AdPriceTests {
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "AdPrice", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
}
