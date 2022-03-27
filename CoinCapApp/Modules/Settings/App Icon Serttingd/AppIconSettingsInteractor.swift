//
//  AppIconSettingsInteractor.swift
//  CoinCapApp
//
//  Created by d.leonova on 27.03.2022.
//

import Foundation
import UIKit

final class AppIconSettingsInteractor: AppIconSettingsDataProvider {
    var output: AppIconSettingsInteractorOutput?
    
    private let userStorage: UserDefaultsStorage
    
    init(
        userStorage: UserDefaultsStorage
    ) {
        self.userStorage = userStorage
    }
    
    func getAllIcons() {
        if let appIconName = userStorage.appIcon,
           let selectedIndex = AppIcon.allCases.firstIndex(of: AppIcon(description: appIconName)) {
            output?.receiveIcons(icons: AppIcon.allCases, selectedIndex: selectedIndex)
        } else {
            output?.receiveIcons(icons: AppIcon.allCases, selectedIndex: 0)
        }
    }
    
    func select(appIcon: AppIcon) {
        UIApplication.shared.setAlternateIconName(appIcon.iconName) { [weak self] error in
            if error == nil,
               let `self` = self {
                self.userStorage.appIcon = appIcon.iconName
                self.getAllIcons()
            }
        }
    }
}
