//
//  FavouriteAdTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class FavouriteAdTests: XCTestCase {
  
  var normalAd: NormalAd!
  
  override func setUp() {
    super.setUp()
    let price = AdPrice(value: 30)
    let photo = AdPhoto(url: "some url")
    normalAd = NormalAd(identifier: "123", location: "some location", adDescription: "some description", price: price.value, photoUri: photo.url, isFavourite: false)
  }
  
  override func tearDown() {
    super.tearDown()
    normalAd = nil
  }
  
  func testIdentifierIsSetByNormalAdOnInit() {
    let favourite = FavouriteAd(normalAd: normalAd)
    XCTAssertEqual(favourite.identifier, normalAd.identifier)
  }
  
  func testLocationIsSetByNormalAdOnInit() {
    let favourite = FavouriteAd(normalAd: normalAd)
    XCTAssertEqual(favourite.location, normalAd.location)
  }
  
  func testDescriptionIsSetByNormalAdOnInit() {
    let favourite = FavouriteAd(normalAd: normalAd)
    XCTAssertEqual(favourite.adDescription, normalAd.adDescription)
  }
  
  func testPriceIsSetByNormalAdOnInit() {
    let favourite = FavouriteAd(normalAd: normalAd)
    XCTAssertEqual(favourite.price, normalAd.price)
  }
  
  func testPhotoUriIsSetByNormalAdOnInit() {
    let favourite = FavouriteAd(normalAd: normalAd)
    XCTAssertEqual(favourite.photoUri, normalAd.photoUri)
  }
  
  func testConversionToNormalAd() {
    let favourite = FavouriteAd(normalAd: normalAd)
    let asNormal = favourite.asNormal()
    XCTAssertEqual(asNormal.identifier, favourite.identifier)
    XCTAssertEqual(asNormal.location, favourite.location)
    XCTAssertEqual(asNormal.price, favourite.price)
    XCTAssertEqual(asNormal.adDescription, favourite.adDescription)
    XCTAssertEqual(asNormal.photoUri, favourite.photoUri)
    XCTAssertTrue(asNormal.isFavourite)
  }
  
}
