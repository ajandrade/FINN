//
//  MockCollectionView.swift
//  FINNTests
//
//  Created by Amadeu Andrade on 11/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit
@testable import FINN

class MockCollectionView: UICollectionView {
  
  var cellGotDequeued = false
  
  static func create() -> MockCollectionView {
    return MockCollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
  }
  
  override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
    cellGotDequeued = true
    return super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
  }
  
}
