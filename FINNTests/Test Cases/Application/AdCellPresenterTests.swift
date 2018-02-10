//
//  AdCellPresenterTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN


class AdCellPresenterTests: XCTestCase {
  
  var presenter: AdCellPresenter!
  var cache: MockCacheProvider!
  var network: MockNetworkProvider!
  var dependencies: AllDependencies!
  
  override func setUp() {
    super.setUp()
    network = MockNetworkProvider()
    cache = MockCacheProvider()
    dependencies = DependencyContainer(network: network, fileManager: FileManagerProvider(), database: DatabaseProvider(nil), cache: cache)
  }
  
  override func tearDown() {
    super.tearDown()
    presenter = nil
    network = nil
    cache = nil
  }
  
  func testIdentifierIsSetByAd() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.identifier, normalAd.identifier)
  }
  
  func testPhotoUriIsSetByAd() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: "uri", isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.photoUri, normalAd.photoUri)
  }
  
  func testIsFavouriteIsSetByAd() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.isFavourite, normalAd.isFavourite)
  }
  
  func testPriceIsSetByAdIfExists() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: 30, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.price, "\(normalAd.price!),-")
  }
  
  func testPriceIsSetAsGisBortIfDoesntExist() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.price, "Gis bort")
  }
  
  func testLocationIsSetByAdIfExists() {
    let normalAd = NormalAd(identifier: "123", location: "loc", adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.location, normalAd.location)
  }
  
  func testLocationIsSetAsUnknownIfDoesntExist() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.location, "Unknown location")
  }
  
  func testAdDescriptionIsSetByAdIfExists() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: "desc", price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.adDescription, normalAd.adDescription)
  }
  
  func testLocationIsSetAsNoDescriptionIfDoesntExist() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertEqual(presenter.adDescription, "No description")
  }

  func testIfCanGetCachedData() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: "uri", isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    XCTAssertFalse(cache.getDataIsCalled)
    _ = presenter.cachedData
    XCTAssertTrue(cache.getDataIsCalled)
  }
  
  func testIfCanDownloadImage() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    let downloadExpectation = expectation(description: "Needs to call downloadImage on NetworkProvider")
    XCTAssertFalse(network.downloadIsCalled)
    presenter.downloadImage(for: "") { _ in
      XCTAssertTrue(self.network.downloadIsCalled)
      downloadExpectation.fulfill()
    }
    wait(for: [downloadExpectation], timeout: 1)
  }
  
  func testIfDataIsCachedOnDownload() {
    let normalAd = NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: normalAd)
    let isCachedExpectation = expectation(description: "Needs to add data to cache")
    XCTAssertFalse(cache.isCached)
    presenter.downloadImage(for: "") { _ in
      XCTAssertTrue(self.cache.isCached)
      isCachedExpectation.fulfill()
    }
    wait(for: [isCachedExpectation], timeout: 1)
  }
  
}
