//
//  AppDelegate.swift
//  HLPageView
//
//  Created by mac on 2019/11/8.
//  Copyright © 2019 HL. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        
        let nav = UINavigationController.init(rootViewController: HomeViewController())
        nav.navigationBar.isTranslucent = false
        
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

