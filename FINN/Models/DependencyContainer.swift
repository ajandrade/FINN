//
//  DependencyContainer.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
import RealmSwift

typealias AllDependencies = HasNetworkProvider & HasImageProvider & HasDatabaseProvider & HasCacheProvider

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
  
  static func build() -> DependencyContainer {
    let network = NetworkProvider()
    let image = ImageProvider()
    let cache = CacheProvider()
    let realm = try? Realm(configuration: RealmConfig.main.configuration)
    let database = DatabaseProvider(realm)
    
    let dependencyContainer = DependencyContainer(network: network, image: image, database: database, cache: cache)
    
    return dependencyContainer
  }

}
