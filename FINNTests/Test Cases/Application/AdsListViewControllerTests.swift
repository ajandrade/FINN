//
//  AdsListViewControllerTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdsListViewControllerTests: XCTestCase {
  
  // MARK: - PROPERTIES

  var viewController: AdsListViewController!
  var presenter: MockAdsListPresenter!

  // MARK: - SETUP

  override func setUp() {
    super.setUp()
    viewController = AdsListViewController()
    presenter = MockAdsListPresenter()
    viewController.presenter = presenter
    viewController.loadViewIfNeeded()
  }
  
  override func tearDown() {
    super.tearDown()
    viewController = nil
    presenter = nil
  }
  
  // MARK: - TEST IBOUTLETS
  
  func testCollectionViewIsConnected() {
    XCTAssertNotNil(viewController.collectionView)
  }
  
  func testFavouriteSwitchIsConnected() {
    XCTAssertNotNil(viewController.favouritesSwitch)
  }
  
  func testFavouriteButtonActionIsConnected() {
    guard let actions = viewController.favouritesSwitch.actions(forTarget: viewController, forControlEvent: .valueChanged) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("switchDidChange:"))
  }
  
  // MARK: - TEST DATA IS SET BY PRESENTER
  
  func testInitialDataIsLoaded() {
    XCTAssertTrue(presenter.initialDataIsLoaded)
  }
  
  func testCollectionViewDataSourceIsSetByPresenter() {
    XCTAssertFalse(presenter.numberOfItemsIsCalled)
    _ = viewController.collectionView.numberOfItems(inSection: 0)
    XCTAssertTrue(presenter.numberOfItemsIsCalled)
  }

  // MARK: - TEST COLLECTION VIEW
  
  func testCollectionViewDelegateIsSet() {
    XCTAssertNotNil(viewController.collectionView.delegate)
  }
  
  func testCollectionViewDataSourceIsSet() {
    XCTAssertNotNil(viewController.collectionView.dataSource)
  }

  func testAddCellIsRegisteredOnCollectionView() {
    let collectionView = viewController.collectionView
    let cell = collectionView?.dequeueReusableCell(withReuseIdentifier: AdCell.identifier, for: IndexPath(item: 0, section: 0))
    XCTAssertNotNil(cell)
  }
  
  func testItemForCellIsDequeueingCells() {
    let mockCollectionView = MockCollectionView.create()
    viewController.collectionView = mockCollectionView
    mockCollectionView.dataSource = viewController
    XCTAssertFalse(mockCollectionView.cellGotDequeued)
    let _ = viewController.collectionView(mockCollectionView, cellForItemAt: IndexPath(item: 0, section: 0))
    XCTAssertTrue(mockCollectionView.cellGotDequeued)
  }
  
  func testCellIsAdCell() {
    let mockCollectionView = MockCollectionView.create()
    viewController.collectionView = mockCollectionView
    mockCollectionView.dataSource = viewController
    let cell = viewController.collectionView(mockCollectionView, cellForItemAt: IndexPath(item: 0, section: 0))
    XCTAssertTrue(cell is AdCell)
  }
  
  func testCellFavouriteSelectedIsSet() {
    XCTAssertFalse(presenter.setFavouriteIsCalled)
    let cell = viewController.collectionView(viewController.collectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as! AdCell
    cell.favouriteSelected?(true)
    XCTAssertTrue(presenter.setFavouriteIsCalled)
  }
  
  func testPrefetchingIsSet() {
    XCTAssertFalse(presenter.isPrefetching)
    viewController.collectionView(viewController.collectionView, prefetchItemsAt: [IndexPath(item: 0, section: 0)])
    XCTAssertTrue(presenter.isPrefetching)
  }
 
  func testCancelPrefetchIsSet() {
    XCTAssertFalse(presenter.isCancelingPrefetch)
    viewController.collectionView(viewController.collectionView, cancelPrefetchingForItemsAt: [IndexPath(item: 0, section: 0)])
    XCTAssertTrue(presenter.isCancelingPrefetch)
  }
  
  // MARK: - TEST IBACTIONS

  func testOnSwitchPressedToChangeData() {
    XCTAssertFalse(presenter.switchDataIsCalled)
    viewController.switchDidChange(viewController.favouritesSwitch)
    XCTAssertTrue(presenter.switchDataIsCalled)
  }

}
