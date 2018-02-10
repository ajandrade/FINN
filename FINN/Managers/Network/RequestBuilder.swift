//
//  RequestBuilder.swift
//  FINN
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

struct RequestBuilder {
  
  enum RequestType { case ads, images(String) }
  
  private init() {}
  
  static func build(for type: RequestType) -> URLRequest? {
    switch type {
    case .ads:
      return try? FINNAdsAPI.adsList.asURLRequest()
    case .images(let uri):
      return try? FINNImageAPI.image(uri).asURLRequest()
    }
  }
  
}
