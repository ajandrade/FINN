//
//  FileManagerError.swift
//  FINN
//
//  Created by Amadeu Andrade on 07/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum FileManagerError: Swift.Error {
  case deleting
  case writing
  case doesntExist
}

extension FileManagerError: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .deleting:
      return "Error while deleting from file manager."
    case .writing:
      return "Error while writing to file manager."
    case .doesntExist:
      return "File does not exist."
    }
  }
  
}
