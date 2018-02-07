//
//  RealmConfig.swift
//  FINN
//
//  Created by Amadeu Andrade on 07/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import RealmSwift

enum RealmConfig {
  case main
  case test
  
  var configuration: Realm.Configuration {
    switch self {
    case .main:
      return Realm.Configuration.defaultConfiguration
    case .test:
      return Realm.Configuration(inMemoryIdentifier: "test", deleteRealmIfMigrationNeeded: true)        
    }
  }
  
}
