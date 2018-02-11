//
//  MockDatabaseProvider.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 11/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
import RealmSwift

@testable import FINN

class MockDatabaseProvider: DatabaseProviderRepresentable {
  
  enum State { case success, failure }
  
  private let state: State
  
  var createdIsCalled = false
  var deletedIsCalled = false

  init(for state: State) {
    self.state = state
  }
  
  func get(by key: String, _ completion: @escaping (Result<FavouriteAd, DatabaseError>) -> Void) {
    switch state {
    case .success:
      let favourite = FavouriteAd()
      completion(.success(favourite))
    case .failure:
      completion(.failure(DatabaseError.notFound))
    }
  }
  
  func getAll(_ completion: @escaping (Result<FavouriteAds, DatabaseError>) -> Void) {
    switch state {
    case .success:
      completion(.failure(DatabaseError.noRealmFile))
    case .failure:
      completion(.failure(DatabaseError.notFound))
    }
  }
  
  func create(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void) {
    createdIsCalled = true
    completion(.success(()))
  }
  
  func delete(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void) {
    deletedIsCalled = true
    completion(.success(()))
  }
  
}

