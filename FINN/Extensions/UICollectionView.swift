//
//  UICollectionView.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

extension UICollectionView {
  
  func register<T: UICollectionViewCell>(_: T.Type) {
    let nib = UINib(nibName: T.identifier, bundle: nil)
    register(nib, forCellWithReuseIdentifier: T.identifier)
  }
  
  func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
      fatalError("Could not dequeuce cell with id: \(T.identifier)")
    }
    return cell
  }
  
}
