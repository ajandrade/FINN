//
//  MockURLSessionDataTask.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {
  private let data: Data?
  private let urlResponse: URLResponse?
  private let responseError: Error?
  
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
  
  var completionHandler: CompletionHandler?
  
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.responseError = error
  }
  
  override func resume() {
    DispatchQueue.main.async() {
      self.completionHandler?(self.data, self.urlResponse, self.responseError)
    }
  }
  
  override func cancel() { }
  
}

