//
//  NetworkProvider.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import Foundation

protocol NetworkProviderRepresentable {
  func getAds(_ completion: @escaping (Result<Data, NetworkError>) -> Void)
}

struct NetworkProvider: NetworkProviderRepresentable {
  
  // MARK: - PROPERTIES
  
  private let session: URLSessionProtocol
  
  // MARK: - INITIALIZER
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
  }
  
  // MARK: - FUNCTIONS
  
  func getAds(_ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    let urlRequest: URLRequest
    do {
      urlRequest = try FINNAdsAPI.adsList.asURLRequest()
    } catch {
      completion(.failure(NetworkError.wrongUrl(FINNAdsAPI.baseURLString)))
      return
    }
    
    let task = session.dataTask(with: urlRequest) { responseData, response, _ in
      guard let response = response, let data = responseData else {
        completion(.failure(NetworkError.unknown))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse else {
        completion(.failure(NetworkError.badResponse))
        return
      }
      guard (200...299).contains(httpResponse.statusCode) else {
        completion(.failure(NetworkError.withCode(httpResponse.statusCode)))
        return
      }
      completion(.success(data))
    }
    
    task.resume()
  }
  
}
