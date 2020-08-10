//
//  AppDelegate.swift
//  Transformers
//
//  Created by Suneeth on 8/6/20.
//  Copyright © 2020 Suneeth. All rights reserved.
//

import UIKit
import CoreData

let APPLICATION = UIApplication.shared
let APP_DELEGATE = APPLICATION.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setCustomRootViewController()
        return true
    }
    private func setCustomRootViewController() {
        let homeNavigationController = HomeSharedViewController()
        homeNavigationController.viewModel = HomeSharedViewModel(with: .home)
        window?.rootViewController = homeNavigationController
    }
}
