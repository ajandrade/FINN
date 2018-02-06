//
//  DependencyContainer.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

typealias AllDependencies = HasNetworkProvider & HasImageProvider & HasDatabaseProvider

protocol HasNetworkProvider {
  var network: NetworkProviderRepresentable { get }
}

protocol HasImageProvider {
  var image: ImageProviderRepresentable { get }
}

protocol HasDatabaseProvider {
  var database: DatabaseProviderRepresentable { get }
}

protocol HasCacheProvider {
  var cache: CacheProviderRepresentable { get }
}

struct DependencyContainer: AllDependencies {
  let network: NetworkProviderRepresentable
  let image: ImageProviderRepresentable
  let database: DatabaseProviderRepresentable
  let cache: CacheProviderRepresentable
}
