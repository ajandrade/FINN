//
//  DatabaseError.swift
//  FINN
//
//  Created by Amadeu Andrade on 07/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum DatabaseError: Swift.Error {
  case deleting
  case writing
  case noRealmFile
  case notFound
}

extension DatabaseError: CustomStringConvertible {
  
  var description: String {
    switch self {
    case .deleting:
      return "Error while deleting from DB."
    case .writing:
      return "Error while writing to DB."
    case .noRealmFile:
      return "There is no DB file."
    case .notFound:
      return "Ad not found."
    }
  }
  
}
