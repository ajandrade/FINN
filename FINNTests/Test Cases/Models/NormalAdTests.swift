//
//  NormalAdTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class NormalAdTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testIsDecodable() {
    let data = loadJSONData()
    let normalAd = try? JSONDecoder().decode(NormalAd.self, from: data)
    XCTAssertNotNil(normalAd)
  }
  
  func testIdentifierIsSetOnInit() {
    let id = "123"
    let normalAd = NormalAd(identifier: id, location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: false)
    XCTAssertEqual(normalAd.identifier, id)
  }
  
  func testLocationIsSetOnInit() {
    let location = "some location"
    let normalAd = NormalAd(identifier: "", location: location, adDescription: nil, price: nil, photoUri: nil, isFavourite: false)
    XCTAssertEqual(normalAd.location, location)
  }
  
  func testAdDescriptionIsSetOnInit() {
    let description = "some description"
    let normalAd = NormalAd(identifier: "", location: nil, adDescription: description, price: nil, photoUri: nil, isFavourite: false)
    XCTAssertEqual(normalAd.adDescription, description)
  }
  
  func testPriceIsSetOnInit() {
    let price = AdPrice(value: 30)
    let normalAd = NormalAd(identifier: "", location: nil, adDescription: nil, price: price.value, photoUri: nil, isFavourite: false)
    XCTAssertEqual(normalAd.price, price.value)
  }
  
  func testPhotoUriIsSetOnInit() {
    let photo = AdPhoto(url: "some url")
    let normalAd = NormalAd(identifier: "", location: nil, adDescription: nil, price: nil, photoUri: photo.url, isFavourite: false)
    XCTAssertEqual(normalAd.photoUri, photo.url)
  }

  func testFavoutireIsSetOnInit() {
    let isFavourite = true
    let normalAd = NormalAd(identifier: "", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: isFavourite)
    XCTAssertEqual(normalAd.isFavourite, isFavourite)
  }
    
}

extension NormalAdTests {
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "NormalAd", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
}
