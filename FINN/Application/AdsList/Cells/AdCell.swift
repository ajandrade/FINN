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
  
  @IBOutlet weak var priceBackgroundView: UIView!
  @IBOutlet weak var adImageView: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  // MARK: - INITIALIZATION
  
  override func awakeFromNib() {
    super.awakeFromNib()
    priceBackgroundView.round(corners: [.bottomLeft, .topRight], withRadius: 10)
    adImageView.round(withRadius: 10)
  }
  
  // MARK: - CONFIGURATION
  
  func configure(with presenter: AdCellPresenterRepresentable) { }
  
}
