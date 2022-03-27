//
//  SettingsRouter.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import UIKit

final class SettingsRouter: SettingsRouterProtocol {
    var appIconModule: AppIconSettingsModule?
    
    private let userStorage: UserDefaultsStorage
    
    init(
        userStorage: UserDefaultsStorage
    ) {
        self.userStorage = userStorage
    }
    
    func showDetailSettings(for appSettings: AppSettings, viewController viewConroller: UIViewController) {
        switch appSettings {
        case .appIcon:
            appIconModule = AppIconSettingsModule(userStorage: userStorage)
            if let view = appIconModule?.view {
                viewConroller.navigationController?.pushViewController(view, animated: true)
            }
        }
    }
}
