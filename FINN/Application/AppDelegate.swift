//
//  AppDelegate.swift
//  FINN
//
//  Created by Amadeu Andrade on 04/02/2018.
//  Copyright © 2018 Amadeu Andrade. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    setRootWindow()
    return true
  }
  
  private func setRootWindow() {
    window = UIWindow(frame: UIScreen.main.bounds)
    let adsListViewController = AdsListViewController()
    let adsListPresenter = AdsListPresenter()
    adsListViewController.presenter = adsListPresenter
    window?.rootViewController = adsListViewController
    window?.makeKeyAndVisible()
  }

}

