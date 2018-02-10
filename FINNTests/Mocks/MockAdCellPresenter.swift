//
//  MockAdCellPresenter.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 10/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit
@testable import FINN

class MockAdCellPresenter: AdCellPresenterRepresentable {
  
  var didDownloadImage = false
  
  var identifier: String = "123"
  var photoUri: String?
  var price: String = "10"
  var location: String = "Oslo"
  var adDescription: String = "..."
  var isFavourite: Bool
  
  var cachedData: Data?
  
  init(isFavourite: Bool = false, photoUri: String? = nil, cachedData: Data? = nil) {
    self.isFavourite = isFavourite
    self.photoUri = photoUri
    self.cachedData = cachedData
  }
  
  func downloadImage(for uri: String, _ completion: @escaping (Result<Data, NetworkError>) -> Void) {
    didDownloadImage = true
    let image = #imageLiteral(resourceName: "HeartSelected")
    let data = UIImagePNGRepresentation(image)!
    cachedData = data
    completion(.success(data))
  }

}
