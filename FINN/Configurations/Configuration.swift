//
//  Configuration.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum Configuration {
  
  enum Network {
    case FINNAPISchema
    case FINNAPIBasePath
    case FINNImageSchema
    case FINNImageBasePath
    
    var value: String {
      switch self {
      case .FINNAPISchema:
        guard let schema = Bundle.main.object(forInfoDictionaryKey: "FINN_API_SCHEME") as? String else {
          fatalError("Key not found: 'FINN_API_SCHEME')")
        }
        return schema
      case .FINNAPIBasePath:
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "FINN_BASE_PATH") as? String else {
          fatalError("Key not found: 'FINN_BASE_PATH')")
        }
        return basePath
      case .FINNImageSchema:
        guard let schema = Bundle.main.object(forInfoDictionaryKey: "FINN_IMAGE_SCHEME") as? String else {
          fatalError("Key not found: 'FINN_IMAGE_SCHEME')")
        }
        return schema
      case .FINNImageBasePath:
        guard let basePath = Bundle.main.object(forInfoDictionaryKey: "FINN_IMAGE_PATH") as? String else {
          fatalError("Key not found: 'FINN_IMAGE_PATH')")
        }
        return basePath
      }
    }
  }
  
}
