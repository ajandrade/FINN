//
//  FINNAPI.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum FINNAPI {
  case adsList
}

extension FINNAPI: API {
  
  static var baseURLString: String {
    return ""
  }
  
  var method: String {
    switch self {
    case .adsList:
      return HTTPMethod.get.rawValue
    }
  }
  
  var path: String {
    switch self {
    case .adsList:
      return ""
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    default:
      return nil
    }
  }
  
  func asURLRequest() -> URLRequest {
    guard var url = URL(string: FINNAPI.baseURLString) else { fatalError("URL is not valid.") }
    url = url.appendingPathComponent(self.path)
    var request = URLRequest(url: url)
    request.httpMethod = method
    if let parameters = self.parameters,
      let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
      request.httpBody = data
    }
    return request
  }
  
}
