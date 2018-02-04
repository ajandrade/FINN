//
//  API.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol API {
  static var baseURLString: String { get }
  var method: String { get }
  var path: String { get }
  var parameters: [String: Any]? { get }
  func asURLRequest() throws -> URLRequest
}
