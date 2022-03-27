//
//  AppIconSettingsPresenter.swift
//  CoinCapApp
//
//  Created by d.leonova on 27.03.2022.
//

import UIKit

final class AppIconSettingsPresenter: AppIconSettingsEventsHandler,
                                      AppIconSettingsInteractorOutput {
    var dataProvider: AppIconSettingsDataProvider?
    var view: AppIconSettingsView?
    
    private var icons = [AppIcon]()
    
    func iconSettingsView(_ view: AppIconSettingsView, didSelectIconAt index: Int) {
        dataProvider?.select(appIcon: icons[index])
    }
    
    func receiveIcons(icons: [AppIcon], selectedIndex: Int) {
        self.icons = icons
        view?.update(icons: icons.map { $0.description }, selectedIndex: selectedIndex)
    }
}
