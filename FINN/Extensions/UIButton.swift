//
//  UIButton.swift
//  FINN
//
//  Created by Amadeu Andrade on 05/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

extension UIButton {
  
  func setImageForAllStates(_ image: UIImage?) {
    setImage(image, for: .normal)
    setImage(image, for: .highlighted)
    setImage(image, for: .selected)
  }
  
}
