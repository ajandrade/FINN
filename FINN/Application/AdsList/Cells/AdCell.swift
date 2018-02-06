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
  
  @IBOutlet weak var downloadIndicatorView: UIActivityIndicatorView!
  @IBOutlet weak var priceBackgroundView: PriceSemiRoundedView!
  @IBOutlet weak var adImageView: AdPhotoImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var favouriteButton: UIButton!
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
  
  // MARK: - PRIVATE PROPERTIES
  
  private let deselectedImage = UIImage(named: "HeartDeselected")
  private let selectedImage = UIImage(named: "HeartSelected")
  
  // MARK: - PROPERTIES
  
  var favouriteSelected: (() -> Void)?
  
  // MARK: - CONFIGURATION
  
  func configure(with presenter: AdCellPresenterRepresentable) {
    priceLabel.text = presenter.price
    locationLabel.text = presenter.location
    descriptionLabel.text = presenter.adDescription
    if presenter.isFavourite {
      favouriteButton.setImageForAllStates(selectedImage)
    } else {
      favouriteButton.setImageForAllStates(deselectedImage)
    }

    /* TODOs:
     - Add cache
     - Add default image
    */
    if let uri = presenter.photoUri {
      downloadIndicatorView.startAnimating()
      presenter.downloadImage(for: uri, { [weak self] result in
        guard let `self` = self else { return }
        DispatchQueue.main.async {
          self.downloadIndicatorView.stopAnimating()
        }
        switch result {
        case .success(let data):
          let image = UIImage(data: data)
          DispatchQueue.main.async {
            self.adImageView.image = image
          }
        case .failure:
          self.adImageView.image = nil
        }
      })
    } else {
      adImageView.image = nil
    }
  }
  
  // MARK: - IBACTIONS
  
  @IBAction func onFavouritePressed(_ sender: UIButton) {
    favouriteSelected?()
  }
  
}
