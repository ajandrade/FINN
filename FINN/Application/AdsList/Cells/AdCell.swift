//
//  AdCell.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

class AdCell: UICollectionViewCell {
  
  // MARK: - IBOUTLETS
  
  @IBOutlet weak var priceBackgroundView: PriceSemiRoundedView!
  @IBOutlet weak var adImageView: AdPhotoImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var favouriteButton: UIButton!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  // MARK: - PROPERTIES
  
  private var isFavourite: Bool = false
  
  var favouriteSelected: (() -> Void)?
    
  // MARK: - CONFIGURATION
  
  func configure(with presenter: AdCellPresenterRepresentable) {
    //TODO: - Add image
    priceLabel.text = presenter.price
    locationLabel.text = presenter.location
    descriptionLabel.text = presenter.adDescription
    if presenter.isFavourite {
      favouriteButton.setImageForAllStates(UIImage(named: "HeartSelected"))
    } else {
      favouriteButton.setImageForAllStates(UIImage(named: "HeartDeselected"))
    }
  }
  
  // MARK: - IBACTIONS
  
  @IBAction func onFavouritePressed(_ sender: UIButton) {
    favouriteSelected?()
  }
  
}
