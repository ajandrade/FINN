//
//  AdsListPresenter.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol AdsListPresenterRepresentable { }

class AdsListPresenter: AdsListPresenterRepresentable {
  
  // MARK: - DEPENDENCIES
  
  typealias Dependencies = HasNetworkProvider & HasImageProvider & HasDatabaseProvider
  private let dependencies: Dependencies
  
  // MARK: - INITIALIZER
  
  init(dependencies: DependencyContainer) {
    self.dependencies = dependencies
  }
  
}
