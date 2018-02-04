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
    let dependencies = buildDependencies()
    let adsListViewController = AdsListViewController()
    let adsListPresenter = AdsListPresenter(dependencies: dependencies)
    adsListViewController.presenter = adsListPresenter
    window?.rootViewController = adsListViewController
    window?.makeKeyAndVisible()
  }
  
  private func buildDependencies() -> DependencyContainer {
    let network = NetworkProvider()
    let image = ImageProvider()
    let database = DatabaseProvider()
    let dependencyContainer = DependencyContainer(network: network, image: image, database: database)
    return dependencyContainer
  }
  
}
