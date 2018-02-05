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
    
    presenter.getAllAds { [weak self] result in
      guard let `self` = self else { return }
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.collectionView.reloadData()
        }
        print("Ok")
      case .failure(let err):
        print(err.description)
      }
    }
  }
  
}

extension AdsListViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let item = presenter.item(for: indexPath.row) else { return AdCell() }
    let cell = collectionView.dequeueCell(for: indexPath) as AdCell
    cell.configure(with: item)
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
