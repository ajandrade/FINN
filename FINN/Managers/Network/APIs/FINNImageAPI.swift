//
//  FINNImageAPI.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum FINNImageAPI {
  case image
}

extension FINNImageAPI: API {
  
  static var baseURLString: String {
    let scheme = Configuration.Network.FINNImageSchema.value
    let path = Configuration.Network.FINNImageBasePath.value
    return "\(scheme)://\(path)/"
  }
  
  var method: String {
    switch self {
    case .image:
      return HTTPMethod.get.rawValue
    }
  }
  
  var path: String {
    switch self {
    case .image:
      return "dynamic/480x360c/"
    }
  }
  
  var parameters: [String: Any]? {
    switch self {
    default:
      return nil
    }
  }
  
  func asURLRequest() throws -> URLRequest {
    guard var url = URL(string: FINNImageAPI.baseURLString) else {
      throw NetworkError.wrongUrl(FINNImageAPI.baseURLString)
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
