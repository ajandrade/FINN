//
//  FileManagerProviderTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 09/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class FileManagerProviderTests: XCTestCase {
  
  var fileManager: FileManagerProvider!
  var key: String!
  var data: Data!

  override func setUp() {
    super.setUp()
    fileManager = FileManagerProvider()
    key = "testKey"
    data = Data()
  }
  
  override func tearDown() {
    super.tearDown()
    fileManager.delete(key) { _ in }
    fileManager = nil
    key = nil
    data = nil
  }
  
  func testWriteAndLoadFile() {
    let writeExpectation = expectation(description: "saved")
    fileManager.write(data, for: key) { result in
      switch result {
      case .success:
        self.fileManager.load(from: self.key, { result in
          switch result {
          case .success(let data):
            XCTAssertNotNil(data)
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
  
  func testDeleteFile() {
    let deleteExpectation = expectation(description: "deleted")
    // Write
    fileManager.write(data, for: key) { result in
      switch result {
      case .success:
        // Delete
        self.fileManager.delete(self.key, { result in
          switch result {
          case .success:
            // Check if exists
            self.fileManager.load(from: self.key, { result in
              switch result {
              case .success: XCTFail()
              case .failure: deleteExpectation.fulfill()
              }
            })
          case .failure: XCTFail()
          }
        })
      case .failure:
        XCTFail()
      }
    }
    wait(for: [deleteExpectation], timeout: 1)
  }
  
}
