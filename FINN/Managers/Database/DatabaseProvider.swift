//
//  DatabaseProvider.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation
import RealmSwift

typealias FavouriteAds = Results<FavouriteAd>

protocol DatabaseProviderRepresentable {
  func get(by key: String, _ completion: @escaping (Result<FavouriteAd, DatabaseError>) -> Void)
  func getAll(_ completion: @escaping (Result<FavouriteAds, DatabaseError>) -> Void)
  func create(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void)
  func delete(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void)
}

class DatabaseProvider: DatabaseProviderRepresentable {
  
  // MARK: - PRIVATE PROPERTIES
  
  private let realm: Realm?
  
  // MARK: - INITIALIZER
  
  init(_ realm: Realm?) {
    self.realm = realm
  }
  
  // MARK: - FUNCTIONS
  
  func get(by key: String, _ completion: @escaping (Result<FavouriteAd, DatabaseError>) -> Void) {
    guard let realm = realm else { completion(.failure(DatabaseError.noRealmFile)); return }
    if let favourite = realm.object(ofType: FavouriteAd.self, forPrimaryKey: key) {
      completion(.success(favourite))
    } else {
      completion(.failure(DatabaseError.notFound))
    }
  }
  
  func getAll(_ completion: @escaping (Result<FavouriteAds, DatabaseError>) -> Void) {
    guard let realm = realm else { completion(.failure(DatabaseError.noRealmFile)); return }
    
    let ads = realm.objects(FavouriteAd.self)
    completion(.success(ads))
  }
  
  func create(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void) {
    guard let realm = realm else { completion(.failure(DatabaseError.noRealmFile)); return }
    
    do {
      try realm.write {
        realm.add(favouriteAd)
        completion(.success(()))
      }
    } catch {
      completion(.failure(DatabaseError.writing))
    }
  }
  
  func delete(_ favouriteAd: FavouriteAd, _ completion: @escaping (Result<Void, DatabaseError>) -> Void) {
    guard let realm = realm else { completion(.failure(DatabaseError.noRealmFile)); return }
    
    do {
      try realm.write {
        realm.delete(favouriteAd)
        completion(.success(()))
      }
    } catch {
      completion(.failure(DatabaseError.deleting))
    }
  }
  
}
