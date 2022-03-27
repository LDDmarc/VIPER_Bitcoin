//
//  AppGraph.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import UIKit

final class AppGraph {
    private let tabBarController = MainTabBarController()
    private let assetsModule: AssetsModule
    private let watchListModule: WatchListAssetsModule
    private let settingsModule: SettingsModule
    
    var rootViewController: UIViewController {
         tabBarController
    }
    
    init() {
        let networkService = NetworkService()
        let userStorage = UserDefaultsStorage()
        
        assetsModule = AssetsModule(
            userStorage: userStorage,
            networkService: networkService
        )
        watchListModule = WatchListAssetsModule(
            userStorage: userStorage,
            networkService: networkService
        )
        settingsModule = SettingsModule(
            userStorage: userStorage
        )
        
        //assets
        let assetsListViewController = assetsModule.view
        assetsListViewController.title = "assets_list_view_controller_title".localized()
        assetsListViewController.tabBarItem = UITabBarItem(
            title: "assets_list_tab_bar_item_title".localized(),
            image: UIImage(named: "bitcoinsign.circle.fill")!,
            selectedImage: nil
        )
        let assetsViewController = UINavigationController(rootViewController: assetsListViewController)
        assetsViewController.navigationBar.prefersLargeTitles = true
        
        // watch list
        let watchListAssetsViewController = watchListModule.view
        watchListAssetsViewController.title = "watch_list_assets_list_view_controller_title".localized()
        watchListAssetsViewController.tabBarItem = UITabBarItem(
            title: "watch_list_assets_list_tab_bar_item_title".localized(),
            image: UIImage(named: "heart.fill")!,
            selectedImage: nil
        )
        watchListAssetsViewController.searchBarIsHidden = true
        watchListAssetsViewController.pullToRefreshIsEnabled = false
        watchListAssetsViewController.deletingRowsIsEnabled = true
        let watchListViewController = UINavigationController(rootViewController: watchListAssetsViewController)
        watchListViewController.navigationBar.prefersLargeTitles = true
        
        //settings
        let settingsViewController = settingsModule.view
        settingsViewController.title = "settings_view_controller_title".localized()
        settingsViewController.tabBarItem = UITabBarItem(
            title: "settings_tab_bar_item_title".localized(),
            image: UIImage(named: "gearshape.fill")!,
            selectedImage: nil
        )
        let settingsNavViewController = UINavigationController(rootViewController: settingsViewController)
        settingsNavViewController.navigationBar.prefersLargeTitles = true
        
        tabBarController.viewControllers = [
            assetsViewController,
            watchListViewController,
            settingsNavViewController
        ]
    }
}
