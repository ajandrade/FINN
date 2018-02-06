//
//  FINNAdsAPI.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum FINNAdsAPI {
  case adsList
}

extension FINNAdsAPI: API {
  
  static var baseURLString: String {
    let scheme = Configuration.Network.FINNAPISchema.value
    let path = Configuration.Network.FINNAPIBasePath.value
    return "\(scheme)://\(path)"
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
      return "/3lvis/3799feea005ed49942dcb56386ecec2b/raw/63249144485884d279d55f4f3907e37098f55c74/discover.json"
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    default:
      return nil
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    guard var url = URL(string: FINNAdsAPI.baseURLString) else {
      throw NetworkError.wrongUrl(FINNAdsAPI.baseURLString)
    }
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
