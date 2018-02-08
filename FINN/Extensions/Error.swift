//
//  Error.swift
//  FINN
//
//  Created by Amadeu Andrade on 08/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

extension Error {
  
  var message: String {
    if let error = self as? NetworkError {
      return error.description
    } else if let error = self as? DatabaseError {
      return error.description
    } else if let error = self as? FileManagerError {
      return error.description
    } else {
      return self.localizedDescription
    }
  }
  
}
