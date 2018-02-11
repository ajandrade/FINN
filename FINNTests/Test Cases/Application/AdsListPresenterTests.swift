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
  var cache: MockCacheProvider!
  var fileManager: MockFileManagerProvider!
  var database: MockDatabaseProvider!
  
  // MARK: - SETUP
  
  override func setUp() {
    super.setUp()
    network = MockNetworkProvider()
    cache = MockCacheProvider()
    fileManager = MockFileManagerProvider()
    database = MockDatabaseProvider(for: .success)
    let dependencies = DependencyContainer(network: network, fileManager: fileManager, database: database, cache: cache)
    presenter = AdsListPresenter(dependencies: dependencies)
  }
  
  override func tearDown() {
    super.tearDown()
    presenter = nil
    network = nil
    cache = nil
    fileManager = nil
    database = nil
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
  
  func testSetFavouriteWithImage() {
    presenter.loadInitialData { _ in }
    let item = self.presenter.item(for: 0)
    XCTAssertNotNil(item!.photoUri)
    XCTAssertFalse(item!.isFavourite)
    self.presenter.setFavourite(true, for: 0)
    XCTAssertTrue(item!.isFavourite)
    XCTAssertTrue(self.cache.getDataIsCalled)
    XCTAssertTrue(self.database.createdIsCalled)
  }
  
  func testSetFavouriteWithoutImage() {
    presenter.loadInitialData { _ in }
    let item = self.presenter.item(for: 1)
    XCTAssertNil(item!.photoUri)
    XCTAssertFalse(item!.isFavourite)
    self.presenter.setFavourite(true, for: 1)
    XCTAssertTrue(item!.isFavourite)
    XCTAssertFalse(self.cache.getDataIsCalled)
    XCTAssertTrue(self.database.createdIsCalled)
  }
  
  func testSetUnfavourite() {
    presenter.loadInitialData { _ in }
    let item = self.presenter.item(for: 0)
    self.presenter.setFavourite(false, for: 0)
    XCTAssertFalse(item!.isFavourite)
    XCTAssertTrue(self.fileManager.deleteIsCalled)
    XCTAssertTrue(self.database.deletedIsCalled)
  }
  
  func testSwitchDataToFavourites() {
    presenter.switchData(true) { _ in }
    XCTAssertTrue(database.gotFavouritesFromDB)
    XCTAssertFalse(network.getAdsIsCalled)
  }
  
  func testSwitchDataToNormal() {
    presenter.switchData(false) { _ in }
    XCTAssertTrue(database.gotFavouritesFromDB)
    XCTAssertTrue(network.getAdsIsCalled)
  }
  
}
