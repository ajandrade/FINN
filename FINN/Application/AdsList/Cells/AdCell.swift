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
  private var cellDownloadId: String = ""

  // MARK: - PROPERTIES
  
  var favouriteSelected: ((Bool) -> Void)?
  
  // MARK: - CONFIGURATION
  
  func configure(with presenter: AdCellPresenterRepresentable) {
    priceLabel.text = presenter.price
    locationLabel.text = presenter.location
    descriptionLabel.text = presenter.adDescription
    if presenter.isFavourite {
      favouriteButton.isSelected = true
      favouriteButton.setImageForAllStates(selectedImage)
    } else {
      favouriteButton.isSelected = false
      favouriteButton.setImageForAllStates(deselectedImage)
    }
    cellDownloadId = presenter.photoUri ?? ""

    // Check cache to set image
    if let cachedData = presenter.cachedData {
      let image = UIImage(data: cachedData)
      adImageView.image = image
    } else if let uri = presenter.photoUri {
      // Since there is no data hide image
      setNoImage()
      // Download image
      downloadIndicatorView.startAnimating()
      presenter.downloadImage(for: uri, { [weak self] result in
        // Check if cell has been recycled to represent other data.
        guard self?.cellDownloadId == presenter.photoUri else { return }
        // Configure with fetched image
        switch result {
        case .success(let data):
          let image = UIImage(data: data)
          self?.adImageView.image = image
        case .failure:
          self?.setNoImage()
        }
        DispatchQueue.main.async {
          self?.downloadIndicatorView.stopAnimating()
        }
      })
    } else {
      setNoImage()
    }
  }
  
  private func setNoImage() {
    DispatchQueue.main.async {
      self.adImageView.image = nil
      self.adImageView.backgroundColor = UIColor.lightGray
    }
  }
  
  // MARK: - IBACTIONS
  
  @IBAction func onFavouritePressed(_ sender: UIButton) {
    let isFavouriteAlready = sender.isSelected
    if isFavouriteAlready {
      favouriteButton.setImageForAllStates(deselectedImage)
      favouriteSelected?(false)
      favouriteButton.isSelected = false
    } else {
      favouriteButton.setImageForAllStates(selectedImage)
      favouriteSelected?(true)
      favouriteButton.isSelected = true
    }
  }
  
}
