//
//  Identifiable.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol Identifiable { }

extension Identifiable {
  
  static var identifier: String {
    return String(describing: self)
  }
  
}
