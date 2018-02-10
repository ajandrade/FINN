//
//  AdCellTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class AdCellTests: XCTestCase {
  
  var cell: AdCell!
  
  override func setUp() {
    super.setUp()
    let bundle = Bundle(for: AdCell.self)
    cell = bundle.loadNibNamed(AdCell.identifier, owner: nil)!.first as! AdCell
  }
  
  override func tearDown() {
    super.tearDown()
    cell = nil
  }
  
  func testDownloadIndicatorViewIsConnected() {
    XCTAssertNotNil(cell.downloadIndicatorView)
  }
  
  func testPriceBackgroundViewIsConnected() {
    XCTAssertNotNil(cell.priceBackgroundView)
  }
  
  func testAdImageViewIsConnected() {
    XCTAssertNotNil(cell.adImageView)
  }
  
  func testPriceLabelIsConnected() {
    XCTAssertNotNil(cell.priceLabel)
  }
  
  func testLocationLabelIsConnected() {
    XCTAssertNotNil(cell.locationLabel)
  }
  
  func testDescriptionLabelIsConnected() {
    XCTAssertNotNil(cell.descriptionLabel)
  }
  
  func testFavouriteButtonIsConnected() {
    XCTAssertNotNil(cell.favouriteButton)
  }
  
  func testActivityIndicatorViewIsConnected(){
    XCTAssertNotNil(cell.activityIndicatorView)
  }
  
  func testFavouriteButtonActionIsConnected() {
    guard let actions = cell.favouriteButton.actions(forTarget: cell, forControlEvent: .touchUpInside) else { XCTFail(); return }
    XCTAssertTrue(actions.contains("onFavouritePressed:"))
  }
  
  func testPriceLabelIsBeingSetByPresenter() {
    let presenter = MockAdCellPresenter()
    cell.configure(with: presenter)
    XCTAssertEqual(cell.priceLabel.text, presenter.price)
  }
  
  func testLocationLabelIsBeingSetByPresenter() {
    let presenter = MockAdCellPresenter()
    cell.configure(with: presenter)
    XCTAssertEqual(cell.locationLabel.text, presenter.location)
  }
  
  func testDescriptionLabelIsBeingSetByPresenter() {
    let presenter = MockAdCellPresenter()
    cell.configure(with: presenter)
    XCTAssertEqual(cell.descriptionLabel.text, presenter.adDescription)
  }
  
  func testFavouriteButtonSelectedBeingSetByPresenter() {
    let presenter = MockAdCellPresenter(isFavourite: true)
    cell.configure(with: presenter)
    XCTAssertEqual(cell.favouriteButton.isSelected, true)
  }
  
  func testFavouriteButtonUnselectedBeingSetByPresenter() {
    let presenter = MockAdCellPresenter(isFavourite: false)
    cell.configure(with: presenter)
    XCTAssertEqual(cell.favouriteButton.isSelected, false)
  }
  
  func testNoImageWhenNoCacheOrNoUri() {
    let presenter = MockAdCellPresenter(photoUri: nil, cachedData: nil)
    cell.configure(with: presenter)
    XCTAssertFalse(presenter.didDownloadImage)
    XCTAssertNil(cell.adImageView.image)
  }
  
  func testImageSetByCachedData() {
    let data = UIImagePNGRepresentation(#imageLiteral(resourceName: "HeartSelected"))
    let presenter = MockAdCellPresenter(photoUri: nil, cachedData: data)
    cell.configure(with: presenter)
    XCTAssertFalse(presenter.didDownloadImage)
    XCTAssertNotNil(cell.adImageView.image)
  }
  
  func testImageSetByUri() {
    let presenter = MockAdCellPresenter(photoUri: "", cachedData: nil)
    cell.configure(with: presenter)
    XCTAssertTrue(presenter.didDownloadImage)
    XCTAssertNotNil(cell.adImageView.image)
  }
  
  func testOnFavouriteButtonPressedToMakeFavourite() {
    let setFavouriteExpectation = expectation(description: "Is favourite")
    cell.favouriteSelected = { favourite in
        XCTAssertTrue(favourite)
        setFavouriteExpectation.fulfill()
    }
    
    cell.favouriteButton.isSelected = false

    cell.onFavouritePressed(cell.favouriteButton)
    
    wait(for: [setFavouriteExpectation], timeout: 1)
  }
  
  func testOnFavouriteButtonPressedToRemoveFavourite() {
    let setUnfavouriteExpectation = expectation(description: "Is not favourite")
    cell.favouriteSelected = { favourite in
      XCTAssertFalse(favourite)
      setUnfavouriteExpectation.fulfill()
    }
    
    cell.favouriteButton.isSelected = true
    
    cell.onFavouritePressed(cell.favouriteButton)
    
    wait(for: [setUnfavouriteExpectation], timeout: 1)
  }


}
