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
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void)
  func cancelTask(for uri: String)
}

class NetworkProvider: NetworkProviderRepresentable {
  
  // MARK: - DEPENDENCIES
  
  private let session: URLSessionProtocol
  
  // MARK: - PROPERTIES
  
  private var tasks = [URLSessionTask]()
  
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
    tasks.append(task)
  }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    let urlRequest: URLRequest
    do {
      urlRequest = try FINNImageAPI.image(uri).asURLRequest()
    } catch {
      completion(.failure(NetworkError.wrongUrl(FINNImageAPI.baseURLString)))
      return
    }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
      if let `data` = data {
        DispatchQueue.main.async {
          completion(.success(data))
        }
      } else {
        completion(.failure(NetworkError.noImage))
      }
    }
    task.resume()
    tasks.append(task)
  }
  
  func cancelTask(for uri: String) {
    guard let urlRequest = try? FINNImageAPI.image(uri).asURLRequest() else { return }
    guard let taskIndex = tasks.index(where: { $0.originalRequest == urlRequest }) else { return }
    let task = tasks[taskIndex]
    task.cancel()
    tasks.remove(at: taskIndex)
  }
  
}
