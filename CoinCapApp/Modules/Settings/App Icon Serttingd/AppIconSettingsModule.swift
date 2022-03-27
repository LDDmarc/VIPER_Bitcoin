//
//  AppIconSettingsModule.swift
//  CoinCapApp
//
//  Created by d.leonova on 27.03.2022.
//

import Foundation
import UIKit

enum AppIcon: CaseIterable {
    case white
    case black
    case yellow
    
    var description: String {
        switch self {
        case .white:
            return "white_app_icon".localized()
        case .black:
            return "black_app_icon".localized()
        case .yellow:
            return "yellow_app_icon".localized()
        }
    }
    
    var iconName: String {
        switch self {
        case .white:
            return "AppIconAlternate1"
        case .black:
            return "AppIconAlternate2"
        case .yellow:
            return "AppIconAlternate3"
        }
    }
    
    init(description: String) {
        switch description {
        case "AppIconAlternate2":
            self = .black
        case "AppIconAlternate3":
            self = .yellow
        default:
            self = .white
        }
    }
}

protocol AppIconSettingsInteractorOutput: AnyObject {
    func receiveIcons(icons: [AppIcon], selectedIndex: Int)
}

protocol AppIconSettingsDataProvider {
    func getAllIcons()
    func select(appIcon: AppIcon)
}

protocol AppIconSettingsView: UIViewController {
    func update(icons: [String], selectedIndex: Int)
}

protocol AppIconSettingsEventsHandler: AnyObject {
    func iconSettingsView(_ view: AppIconSettingsView, didSelectIconAt index: Int)
}

final class AppIconSettingsModule {
    let interactor: AppIconSettingsInteractor
    let presenter: AppIconSettingsPresenter
    let view: AppIconSettingsViewController

    init(
        userStorage: UserDefaultsStorage
    ) {
        interactor = AppIconSettingsInteractor(
            userStorage: userStorage
        )
        presenter = AppIconSettingsPresenter()
        view = AppIconSettingsViewController()

        interactor.output = presenter
        presenter.dataProvider = interactor
        presenter.view = view
        view.eventsHandler = presenter

        interactor.getAllIcons()
    }
}
