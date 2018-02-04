//
//  NetworkError.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum NetworkError: Swift.Error {
  case unknown
  case wrongUrl(String)
  case badResponse
  case withCode(Int)
  case noConnection

}

extension NetworkError: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .unknown:
      return "General server error."
    case .wrongUrl(let url):
      return url
    case .badResponse:
      return "Response is not NSHTTPURLResponse"
    case .withCode(let code):
      return "Status code: \(code)"
    case .noConnection:
      return "No internet connection."
    }
  }
  
}
