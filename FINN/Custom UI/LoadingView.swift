//
//  LoadingView.swift
//  FINN
//
//  Created by Amadeu Andrade on 06/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

class LoadingView: UIView {
  
  // MARK: - PROPERTIES
  
  var activityIndicator: UIActivityIndicatorView!
  let initialAlpha: CGFloat = 0.8
  let activityIndSize: CGFloat = 50
  var isAnimating: Bool = false
  
  // MARK: - INITIALIZER
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    config()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    config()
  }
  
  convenience init(frame: CGRect, parentView: UIView) {
    self.init(frame: frame)
    parentView.addSubview(self)
  }
  
  convenience init() {
    self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
  }
  
  // MARK: - CONFIGURATION
  
  func config() {
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
    activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
    activityIndicator.hidesWhenStopped = true
    activityIndicator.color = UIColor.darkGray
    
    addSubview(activityIndicator)

    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    let widthConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: activityIndSize)

    let heightConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: activityIndSize)

    let xConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)

    let yConstraint = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)

    NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    
    alpha = 0
    isHidden = true
    backgroundColor = UIColor.white.withAlphaComponent(initialAlpha)
  }
  
  // MARK: - FUNCTIONS
  
  func startAnimating() {
    guard !isAnimating else { return }
    
    DispatchQueue.main.async {
      if self.superview == nil {
        if let window = UIApplication.shared.keyWindow {
          window.addSubview(self)
        }
      } else {
        self.superview?.bringSubview(toFront: self)
      }
      
      self.isHidden = false
      UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
        self.alpha = 1
      }, completion: { _ in
        self.activityIndicator.startAnimating()
      })
      
      self.isAnimating = true
    }
  }
  
  func stopAnimating() {
    DispatchQueue.main.async {
      UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
        self.alpha = 0
      }, completion: { _ in
        self.isHidden = true
        self.activityIndicator.stopAnimating()
        if let window = UIApplication.shared.keyWindow {
          if self.superview == window {
            self.removeFromSuperview()
          }
        }
      })
      
      self.isAnimating = false
    }
  }
  
}
