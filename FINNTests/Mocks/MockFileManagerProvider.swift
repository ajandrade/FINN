//
//  MockFileManagerProvider.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 11/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

@testable import FINN

class MockFileManagerProvider: FileManagerProviderRepresentable {
  
  var loadIsCalled = false
  var writeIsCalled = false
  var deleteIsCalled = false
  
  func load(from identifier: String, _ completion: @escaping (Result<Data, FileManagerError>) -> Void) {
    loadIsCalled = true
    completion(.success(Data()))
  }
  
  func write(_ data: Data, for identifier: String, _ completion: @escaping (Result<Void, FileManagerError>) -> Void) {
    writeIsCalled = true
    completion(.success(()))
  }
  
  func delete(_ identifier: String, _ completion: @escaping (Result<Void, FileManagerError>) -> Void) {
    deleteIsCalled = true
    completion(.success(()))
  }
  
}

