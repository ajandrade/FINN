//
//  MockURLSession.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
@testable import FINN

class MockURLSession: URLSessionProtocol {
  
  let dataTask: MockURLSessionDataTask
  
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    dataTask = MockURLSessionDataTask(data: data, urlResponse: urlResponse, error: error)
  }
  
  func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    dataTask.request = request
    dataTask.completionHandler = completionHandler
    return dataTask
  }
  
}
