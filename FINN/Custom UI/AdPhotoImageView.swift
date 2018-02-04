//
//  AdPhotoImageView.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

class AdPhotoImageView: UIImageView, Roundable {
  
  // MARK: - INITIALIZATION

  override init(frame: CGRect) {
    super.init(frame: frame)
    round(withRadius: 10)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    round(withRadius: 10)
  }
  
}
