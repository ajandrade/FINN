//
//  DependencyContainer.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
import RealmSwift

typealias AllDependencies = HasNetworkProvider & HasFileManagerProvider & HasDatabaseProvider & HasCacheProvider

protocol HasNetworkProvider {
  var network: NetworkProviderRepresentable { get }
}

protocol HasFileManagerProvider {
  var fileManager: FileManagerProviderRepresentable { get }
}

protocol HasDatabaseProvider {
  var database: DatabaseProviderRepresentable { get }
}

protocol HasCacheProvider {
  var cache: CacheProviderRepresentable { get }
}

struct DependencyContainer: AllDependencies {
  let network: NetworkProviderRepresentable
  let fileManager: FileManagerProviderRepresentable
  let database: DatabaseProviderRepresentable
  let cache: CacheProviderRepresentable
  
  static func build() -> DependencyContainer {
    let network = NetworkProvider()
    let fileManager = FileManagerProvider()
    let cache = CacheProvider()
    let realm = try? Realm(configuration: RealmConfig.main.configuration)
    let database = DatabaseProvider(realm)
    
    let dependencyContainer = DependencyContainer(network: network, fileManager: fileManager, database: database, cache: cache)
    
    return dependencyContainer
  }

}
