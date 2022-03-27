//
//  AppDelegate.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appGraph: AppGraph?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appGraph = AppGraph()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = appGraph?.rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

