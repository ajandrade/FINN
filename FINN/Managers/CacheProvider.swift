//
//  CacheProvider.swift
//  FINN
//
//  Created by Amadeu Andrade on 06/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

protocol CacheProviderRepresentable {
  func add(_ data: Data, for key: String)
  func getData(forkey key: String) -> Data?
}

class CacheProvider: CacheProviderRepresentable {
  
  // MARK: - PROPERTIES
  
  private let cache = NSCache<NSString, NSData>()
  
  // MARK: - INITIALIZER
  
  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(clearCache), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .UIApplicationDidReceiveMemoryWarning, object: nil)
  }
  
  // MARK: - METHODS
  
  func add(_ data: Data, for key: String) {
    cache.setObject(data as NSData, forKey: key as NSString)
  }
  
  func getData(forkey key: String) -> Data? {
    guard let data = cache.object(forKey: key as NSString) as? Data else { return nil }
    return data
  }
  
  @objc func clearCache() {
    cache.removeAllObjects()
  }
  
}
