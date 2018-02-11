//
//  AdsListPresenterTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 11/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdsListPresenterTests: XCTestCase {
  
  // MARK: - PROPERTIES
  
  var presenter: AdsListPresenter!
  var network: MockNetworkProvider!
  
  // MARK: - SETUP
  
  override func setUp() {
    super.setUp()
    network = MockNetworkProvider()
    let dependencies = DependencyContainer(network: network, fileManager: FileManagerProvider(), database: DatabaseProvider(nil), cache: MockCacheProvider())
    presenter = AdsListPresenter(dependencies: dependencies)
  }
  
  override func tearDown() {
    super.tearDown()
    presenter = nil
  }
  
  // MARK: - TESTS
  
  func testNumberOfItemsIsDataSourceCount() {
    let initialNumber = presenter.numberOfItems
    XCTAssertEqual(initialNumber, 0)
    presenter.loadInitialData { _ in }
    let numberAfterLoad = presenter.numberOfItems
    XCTAssertGreaterThan(numberAfterLoad, 0)
  }
  
  func testGetItemWithIndexOutOfRange() {
    let initialNumber = presenter.numberOfItems
    XCTAssertEqual(initialNumber, 0)
    let item = presenter.item(for: 100)
    XCTAssertNil(item)
  }
  
  func testGetItem() {
    presenter.loadInitialData { _ in }
    XCTAssertGreaterThan(presenter.numberOfItems, 0)
    let item = presenter.item(for: 0)
    XCTAssertNotNil(item)
  }
  
  func testLoadInitialData() {
    XCTAssertFalse(network.getAdsIsCalled)
    presenter.loadInitialData { _ in }
    XCTAssertTrue(network.getAdsIsCalled)
  }

  func testStartPrefetchingByCallingNetworkProvider() {
    presenter.loadInitialData { _ in }
    XCTAssertFalse(network.downloadIsCalled)
    presenter.startPrefetching(for: [0])
    XCTAssertTrue(network.downloadIsCalled)
  }
  
  func testCancelPrefetchingByCallingNetworkProvider() {
    presenter.loadInitialData { _ in }
    XCTAssertFalse(network.cancelIsCalled)
    presenter.cancelPrefetching(for: [0])
    XCTAssertTrue(network.cancelIsCalled)
  }
  
  func testSetFavourite() {
    // item is set
    // image stored // removed
    // saved on db // deleted
  }
  
  func testSwitchData() {
    // to favourites
    // to normal
  }
  
}
