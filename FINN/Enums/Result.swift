//
//  Result.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

enum Result<T, E> {
  case success(T)
  case failure(E)
  
  var value: T? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil
    }
  }
  
  var error: E? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }

}
