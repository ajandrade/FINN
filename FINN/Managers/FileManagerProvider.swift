//
//  FileManagerProvider.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol FileManagerProviderRepresentable {
  func load(from path: URL, _ completion: @escaping (Result<Data, FileManagerError>) -> Void)
  func write(_ data: Data, _ completion: @escaping (Result<URL, FileManagerError>) -> Void)
  func delete(from path: URL, _ completion: @escaping (Result<Void, FileManagerError>) -> Void)
}

class FileManagerProvider: FileManagerProviderRepresentable {
  
  // MARK: - DEPENDENCIES
  
  private let fileManager: FileManager
  
  // MARK: - PROPERTIES
  
  private var getDocumentsDirectory: URL {
    let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
  
  // MARK: - INITIALIZER
  
  init(fileManager: FileManager = FileManager.default) {
    self.fileManager = fileManager
  }
  
  // MARK: - FUNCTIONS
  
  func load(from path: URL, _ completion: @escaping (Result<Data, FileManagerError>) -> Void) {
    if fileManager.fileExists(atPath: path.absoluteString) {
      do {
        let data = try Data(contentsOf: path)
        completion(.success(data))
      } catch {
        completion(.failure(FileManagerError.doesntExist))
      }
    } else {
      completion(.failure(FileManagerError.doesntExist))
    }
  }
  
  func write(_ data: Data, _ completion: @escaping (Result<URL, FileManagerError>) -> Void) {
    let filename = getDocumentsDirectory.appendingPathComponent("\(UUID().uuidString).png")
    do {
      try data.write(to: filename)
      completion(.success(filename))
    } catch {
      completion(.failure(FileManagerError.writing))
    }
  }
  
  func delete(from path: URL, _ completion: @escaping (Result<Void, FileManagerError>) -> Void) {
    do {
      try fileManager.removeItem(at: path)
      completion(.success(()))
    } catch {
      completion(.failure(FileManagerError.deleting))
    }
  }
}
