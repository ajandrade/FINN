//
//  AdPhotoTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdPhotoTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testIsDecodable() {
    let data = loadJSONData()
    let photo = try? JSONDecoder().decode(AdPhoto.self, from: data)
    XCTAssertNotNil(photo)
  }
  
  func testUrlIsSetOnInit() {
    let photo = AdPhoto(url: "some url")
    XCTAssertEqual(photo.url, "some url")
  }
  
}

extension AdPhotoTests {
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "AdPhoto", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
}
