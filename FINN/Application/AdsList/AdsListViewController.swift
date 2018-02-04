//
//  AdsListViewController.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

class AdsListViewController: UIViewController {
  
  // MARK: - DEPENDENCIES
  
  var presenter: AdsListPresenterRepresentable!
  
  // MARK: - IBOUTLETS
  
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet { collectionView.register(AdCell.self) }
  }
  
  // MARK: - VIEW LIFE CYCLE
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

extension AdsListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 30
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueCell(for: indexPath) as AdCell
    cell.favouriteSelected = { [weak self] in
      print("Favourite!")
    }
    return cell
  }
  
}

extension AdsListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
    let height = width + 60
    return CGSize(width: width, height: height)
  }
}

extension AdsListViewController: UICollectionViewDataSourcePrefetching {
  
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    
  }
}
