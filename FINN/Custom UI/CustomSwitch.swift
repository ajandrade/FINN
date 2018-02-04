//
//  CustomSwitch.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

class CustomSwitch: UISwitch {
  
  // MARK: - PRIVATE PROPERTIES
  
  private var backgroundOffColor: UIColor = UIColor(hex: "C2C2C2")
  private var customOnTintColor: UIColor = UIColor.darkGray
  
  // MARK: - INITIALIZATION
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setCustomUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setCustomUI()
  }
  
  // MARK: - CUSTOMIZATION
  
  // swiftlint:disable identifier_name
  override func setOn(_ on: Bool, animated: Bool) {
    super.setOn(on, animated: animated)
    updateUI()
  }
  // swiftlint:enable identifier_name
  
  private func setCustomUI() {
    layer.cornerRadius = 16
    layer.masksToBounds = true
    onTintColor = customOnTintColor
  }
    
  private func updateUI() {
    backgroundColor = isOn ? nil : backgroundOffColor
  }
  
}
