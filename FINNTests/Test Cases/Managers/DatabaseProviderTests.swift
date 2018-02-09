//
//  DatabaseProviderTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 09/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
import RealmSwift
@testable import FINN

class DatabaseProviderTests: XCTestCase {
  
  var database: DatabaseProvider!
  
  override func setUp() {
    super.setUp()
    let testConfig = RealmConfig.test.configuration
    let realm = try! Realm(configuration: testConfig)
    database = DatabaseProvider(realm)
  }
  
  override func tearDown() {
    super.tearDown()
    database = nil
  }
  
  func testSaveOnDatabase() {
    let writeExpectation = expectation(description: "saved")
    
    let key = "123"
    let favouriteAd = FavouriteAd()
    favouriteAd.identifier = key
    
    database.create(favouriteAd) { result in
      switch result {
      case .success:
        // To ensure ad was saved
        self.database.get(by: key, { result in
          switch result {
          case .success(let ad):
            XCTAssertNotNil(ad)
            writeExpectation.fulfill()
          case .failure: XCTFail()
          }
        })
      case .failure:
        XCTFail()
      }
    }
    
    wait(for: [writeExpectation], timeout: 1)
  }
  
  func testGetByKey() {
    let key = "123"
    let favouriteAd = FavouriteAd()
    favouriteAd.identifier = key
    database.create(favouriteAd) { _ in }
    
    let loadedExpectation = expectation(description: "loaded")
    
    database.get(by: key) { result in
      switch result {
      case .success(let ad):
        XCTAssertNotNil(ad)
        loadedExpectation.fulfill()
      case .failure:
        XCTFail()
      }
    }
    
    wait(for: [loadedExpectation], timeout: 1)
  }
  
  func testGetAll() {
    database.create(FavouriteAd()) { _ in }
    
    let loadedExpectation = expectation(description: "loaded")
    
    database.getAll { result in
      switch result {
      case .success(let ads):
        XCTAssertEqual(ads.count, 1)
        loadedExpectation.fulfill()
      case .failure:
        XCTFail()
      }
    }
    
    wait(for: [loadedExpectation], timeout: 1)
  }
  
  func testDelete() {
    let favouriteAd = FavouriteAd()
    database.create(favouriteAd) { _ in }
    
    let deletedExpectation = expectation(description: "deleted")
    
    database.delete(favouriteAd, { result in
      switch result {
      case .success:
        // to ensure ad was deleted
        self.database.getAll { result in
          switch result {
          case .success(let ads):
            XCTAssertEqual(ads.count, 0)
            deletedExpectation.fulfill()
          case .failure:
            XCTFail()
          }
        }
      case .failure:
        XCTFail()
      }
    })
    
    wait(for: [deletedExpectation], timeout: 1)
  }
  
}
