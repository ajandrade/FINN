//
//  RequestBuilderTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class RequestBuilderTests: XCTestCase {
  
  // MARK: - SETUP

  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: - TESTS
  
  func testAdsAPIBaseUrlIsCorrect() {
    let correctBasePath = "https://gist.githubusercontent.com"
    let adsBaseUrl = FINNAdsAPI.baseURLString
    XCTAssertEqual(adsBaseUrl, correctBasePath)
  }
  
  func testImageAPIBaseUrlIsCorrect() {
    let correctBasePath = "https://images.finncdn.no"
    let imagesBaseUrl = FINNImageAPI.baseURLString
    XCTAssertEqual(imagesBaseUrl, correctBasePath)
  }
  
  func testAdsRequestIsCorrect() {
    let endpoint = "https://gist.githubusercontent.com/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json"
    let urlRequest = URLRequest(url: URL(string: endpoint)!)
    let endpointUrlRequest = RequestBuilder.build(for: .ads)
    XCTAssertEqual(endpointUrlRequest, urlRequest)
  }
  
  func testImageRequestIsCorrect() {
    let someUri = "uri"
    let endpoint = "https://images.finncdn.no/dynamic/480x360c/\(someUri)"
    let urlRequest = URLRequest(url: URL(string: endpoint)!)
    let endpointUrlRequest = RequestBuilder.build(for: .images(someUri))
    XCTAssertEqual(endpointUrlRequest, urlRequest)
  }
  
}
