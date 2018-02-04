//
//  Roundable.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

protocol Roundable { }

extension Roundable where Self: UIView {
  
  func round(corners: UIRectCorner, withRadius radius: CGFloat) {
    let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
  func round(withRadius radius: CGFloat) {
    clipsToBounds = true
    layer.cornerRadius = radius
  }
  
}
