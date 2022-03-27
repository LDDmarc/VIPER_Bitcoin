//
//  SettingsInteractor.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import Foundation

final class SettingsInteractor: SettingsDataProvider {
    weak var output: SettingsInteractorOutput?
    
    func getAllSettings() {
        output?.receiveSettings(settings: AppSettings.allCases)
    }
}
