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
  
  // MARK: - PROPERTIES
  
  var presenter: AdCellPresenter!
  var cache: MockCacheProvider!
  var network: MockNetworkProvider!
  var dependencies: AllDependencies!
  
  // MARK: - SETUP

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
  
  // MARK: - TESTS
  
  func testIdentifierIsSetByAd() {
    let ad = createAd(with: .identifier)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.identifier, ad.identifier)
  }
  
  func testPhotoUriIsSetByAd() {
    let ad = createAd(with: .uri)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.photoUri, ad.photoUri)
  }
  
  func testIsFavouriteIsSetByAd() {
    let ad = createAd(with: .isFavourite)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.isFavourite, ad.isFavourite)
  }
  
  func testPriceIsSetByAdIfExists() {
    let ad = createAd(with: .price(true))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.price, "\(ad.price!),-")
  }
  
  func testPriceIsSetAsGisBortIfDoesntExist() {
    let ad = createAd(with: .price(false))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.price, "Gis bort")
  }
  
  func testLocationIsSetByAdIfExists() {
    let ad = createAd(with: .location(true))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.location, ad.location)
  }
  
  func testLocationIsSetAsUnknownIfDoesntExist() {
    let ad = createAd(with: .location(false))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.location, "Unknown location")
  }
  
  func testAdDescriptionIsSetByAdIfExists() {
    let ad = createAd(with: .description(true))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.adDescription, ad.adDescription)
  }
  
  func testLocationIsSetAsNoDescriptionIfDoesntExist() {
    let ad = createAd(with: .description(false))
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertEqual(presenter.adDescription, "No description")
  }

  func testIfCanGetCachedData() {
    let ad = createAd(with: .uri)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    XCTAssertFalse(cache.getDataIsCalled)
    _ = presenter.cachedData
    XCTAssertTrue(cache.getDataIsCalled)
  }
  
  func testIfCanDownloadImage() {
    let ad = createAd(with: .identifier)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    let downloadExpectation = expectation(description: "Needs to call downloadImage on NetworkProvider")
    XCTAssertFalse(network.downloadIsCalled)
    presenter.downloadImage(for: "") { _ in
      XCTAssertTrue(self.network.downloadIsCalled)
      downloadExpectation.fulfill()
    }
    wait(for: [downloadExpectation], timeout: 1)
  }
  
  func testIfDataIsCachedOnDownload() {
    let ad = createAd(with: .identifier)
    presenter = AdCellPresenter(dependencies: dependencies, normalAd: ad)
    let isCachedExpectation = expectation(description: "Needs to add data to cache")
    XCTAssertFalse(cache.isCached)
    presenter.downloadImage(for: "") { _ in
      XCTAssertTrue(self.cache.isCached)
      isCachedExpectation.fulfill()
    }
    wait(for: [isCachedExpectation], timeout: 1)
  }
  
}

extension AdCellPresenterTests {
  
  enum AdType { case identifier, location(Bool), description(Bool), price(Bool), uri, isFavourite }
  
  func createAd(with adType: AdType) -> NormalAd {
    switch adType {
    case .identifier:
      return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    case .location(let hasLocation):
      if hasLocation {
        return NormalAd(identifier: "123", location: "loc", adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
      } else {
        return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
      }
    case .description(let hasDescription):
      if hasDescription {
        return NormalAd(identifier: "123", location: nil, adDescription: "desc", price: nil, photoUri: nil, isFavourite: true)
      } else {
        return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
      }
    case .price(let hasPrice):
      if hasPrice {
        return NormalAd(identifier: "123", location: nil, adDescription: nil, price: 30, photoUri: nil, isFavourite: true)
      } else {
        return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
      }
    case .uri:
      return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: "uri", isFavourite: true)
    case .isFavourite:
      return NormalAd(identifier: "123", location: nil, adDescription: nil, price: nil, photoUri: nil, isFavourite: true)
    }
  }
  
}
