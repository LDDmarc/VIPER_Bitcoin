//
//  WatchListAssetsModule.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

protocol WatchListAssetsInteractorOutput: AnyObject {
    func receiveData(data: [AssetModel])
}

protocol WatchListAssetsListViewDataProvider {
    func loadFavoriteAssets()
    func deleteAsset(assetId: String)
}

protocol WatchListAssetsRouterProtocol {
    func showDetail(for asset: AssetModel, viewController: UIViewController)
}

final class WatchListAssetsModule {
    let interactor: WatchListAssetsInteractor
    let presenter: WatchListAssetsPresenter
    
    let view: ListViewController
    let router: AssetsRouterProtocol
    
    init(
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        interactor = WatchListAssetsInteractor(
            userStorage: userStorage,
            networkService: networkService
        )
        presenter = WatchListAssetsPresenter()
        view = ListViewController()
        router = AssetsRouter(
            userStorage: userStorage,
            networkService: networkService
        )
        
        interactor.output = presenter
        presenter.dataProvider = interactor
        presenter.view = view
        view.eventHandler = presenter
        presenter.router = router
    }
}
