//
//  SettingsPresenter.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import Foundation

final class SettingsPresenter: SettingsEventsHandler,
                               SettingsInteractorOutput {
    var view: SettingsView?
    var dataProvider: SettingsDataProvider?
    var router: SettingsRouter?
    
    private var settings: [AppSettings] = []
    
    func settingsView(_ view: SettingsView, didSelectSettingsAt index: Int) {
        guard index < settings.count else { return }
        router?.showDetailSettings(for: settings[index], viewController: view)
    }
    
    func receiveSettings(settings: [AppSettings]) {
        self.settings = settings
        view?.update(settings: settings)
    }
}
