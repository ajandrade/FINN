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
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  // MARK: - VIEW LIFE CYCLE

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}
