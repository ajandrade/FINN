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
  
  var viewController: AdsListViewController!
  var presenter: MockAdsListPresenter!

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
  
  func testCollectionViewDataSourceIsSetByPresenter() {
    _ = viewController.collectionView.numberOfItems(inSection: 0)
    XCTAssertTrue(presenter.numberOfItemsIsCalled)
  }
  
}
