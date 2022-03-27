//
//  SettingsModule.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import Foundation
import UIKit

enum AppSettings: CaseIterable {
    case appIcon
    
    var desctiption: String {
        switch self {
        case .appIcon:
            return "Icon"
        }
    }
}

protocol SettingsInteractorOutput: AnyObject {
    func receiveSettings(settings: [AppSettings])
}

protocol SettingsDataProvider {
    func getAllSettings()
}

protocol SettingsRouterProtocol {
    func showDetailSettings(for appSettings: AppSettings, viewController: UIViewController)
}

protocol SettingsView: UIViewController {
    func update(settings: [AppSettings])
}

protocol SettingsEventsHandler: AnyObject {
    func settingsView(_ view: SettingsView, didSelectSettingsAt index: Int)
}

final class SettingsModule {
    let interactor: SettingsInteractor
    let presenter: SettingsPresenter
    let view: SettingsViewController
    let router: SettingsRouter
    
    init(
        userStorage: UserDefaultsStorage
    ) {
        interactor = SettingsInteractor()
        presenter = SettingsPresenter()
        view = SettingsViewController()
        router = SettingsRouter(userStorage: userStorage)
        
        interactor.output = presenter
        presenter.dataProvider = interactor
        presenter.view = view
        view.eventHandler = presenter
        presenter.router = router
        
        interactor.getAllSettings()
    }
}
