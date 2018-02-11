//
//  NetworkProviderTests.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import XCTest
@testable import FINN

class NetworkProviderTests: XCTestCase {
  
  // MARK: - PROPERTIES

  var network: NetworkProvider!
  var mockSession: MockURLSession!
  var testData: Data!

  // MARK: - SETUP

  override func setUp() {
    super.setUp()
    testData = loadJSONData()
  }
  
  override func tearDown() {
    super.tearDown()
    testData = nil
    network = nil
    mockSession = nil
  }
  
  // MARK: - TESTS
  
  func testNoResponseErrorIsHandledForAds() {
    mockSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
    network = NetworkProvider(session: mockSession)
    
    let errorExpectation = expectation(description: "Error")
    let errorToMatch = NetworkError.unknown
    
    network.getAds { result in
      if let err = result.error, err.description == errorToMatch.description {
        errorExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [errorExpectation], timeout: 1)
  }
  
  func testNoHTTPResponseIsHandledForAds() {
    let urlResponse = URLResponse()
    mockSession = MockURLSession(data: testData, urlResponse: urlResponse, error: nil)
    network = NetworkProvider(session: mockSession)
    
    let errorExpectation = expectation(description: "Error")
    let errorToMatch = NetworkError.badResponse
    
    network.getAds { result in
      if let err = result.error, err.description == errorToMatch.description {
        errorExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [errorExpectation], timeout: 1)
  }
  
  func testUnsuccessfulStatusCodeIsHandled() {
    let urlResponse = createResponse(for: .ads, for: .failure)
    mockSession = MockURLSession(data: testData, urlResponse: urlResponse, error: nil)
    network = NetworkProvider(session: mockSession)
    
    let errorExpectation = expectation(description: "Error")
    
    network.getAds { result in
      if let err = result.error, case let NetworkError.withCode(code) = err {
        XCTAssertEqual(code, 404)
        errorExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [errorExpectation], timeout: 1)
  }
  
  func testRequestWithNoImageOnResult() {
    mockSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
    network = NetworkProvider(session: mockSession)
    
    let errorExpectation = expectation(description: "Error")
    let errorToMatch = NetworkError.noImage
    
    network.downloadImage(for: "") { result in
      if let err = result.error, err.description == errorToMatch.description {
        errorExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [errorExpectation], timeout: 1)
  }
 
  func testSuccessfulRequestForAds() {
    let urlResponse = createResponse(for: .ads, for: .success)
    mockSession = MockURLSession(data: testData, urlResponse: urlResponse, error: nil)
    network = NetworkProvider(session: mockSession)

    let dataExpectation = expectation(description: "Success!")
    
    network.getAds { result in
      if result.value != nil {
        dataExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [dataExpectation], timeout: 1)
  }
  
  func testSuccessfulRequestForImage() {
    let urlResponse = createResponse(for: .images("uri"), for: .success)
    mockSession = MockURLSession(data: Data(), urlResponse: urlResponse, error: nil)
    network = NetworkProvider(session: mockSession)

    let dataExpectation = expectation(description: "Success!")
    
    network.downloadImage(for: "") { result in
      if result.value != nil {
        dataExpectation.fulfill()
      } else {
        XCTFail()
      }
    }
    
    wait(for: [dataExpectation], timeout: 1)
  }
  
  func testCancelTask() {
    let taskUri = "uri"
    let urlResponse = createResponse(for: .images(taskUri), for: .success)
    mockSession = MockURLSession(data: Data(), urlResponse: urlResponse, error: nil)
    network = NetworkProvider(session: mockSession)
    XCTAssertFalse(mockSession.dataTask.isCancelled)
    network.downloadImage(for: taskUri) { _ in }
    XCTAssertFalse(mockSession.dataTask.isCancelled)
    network.cancelTask(for: taskUri)
    XCTAssertTrue(mockSession.dataTask.isCancelled)
  }
  
}

extension NetworkProviderTests {
  
  enum State { case success, failure }
  
  enum RequestType { case ads, images(String) }
  
  func loadJSONData() -> Data {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.path(forResource: "TestData", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    return data
  }
  
  func createResponse(for type: RequestType, for state: State) -> HTTPURLResponse {
    let request: URLRequest
    switch type {
    case .ads:
      request = RequestBuilder.build(for: .ads)!
    case .images(let uri):
      request = RequestBuilder.build(for: .images(uri))!
    }
    let url = request.url!
    let response: HTTPURLResponse
    switch state {
    case .success:
      response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
    case .failure:
      response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)!
    }
    return response
  }
  
}
