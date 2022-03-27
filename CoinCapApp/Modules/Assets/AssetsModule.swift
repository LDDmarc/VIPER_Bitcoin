//
//  AssetsModule.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import UIKit

protocol AssetsInteractorOutput: AnyObject {
    func receiveData(data: [AssetModel])
    func updateData(newData: [AssetModel])
    func assetsInteractor(_ assetsInteractor: AssetsInteractor, didRecieve error: Error)
}

protocol AssetsListViewDataProvider {
    func loadAssets(curentAssetsCount: Int)
}

protocol AssetsRouterProtocol {
    func showDetail(for asset: AssetModel, viewController: UIViewController)
}

final class AssetsModule {
    let interactor: AssetsInteractor
    let presenter: AssetsListViewPresenter
    let view: ListViewController
    let router: AssetsRouterProtocol
    
    init(
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        interactor = AssetsInteractor(networkService: networkService)
        presenter = AssetsListViewPresenter()
        view = ListViewController()
        router = AssetsRouter(userStorage: userStorage, networkService: networkService)
        
        interactor.output = presenter
        presenter.dataProvider = interactor
        presenter.view = view
        view.eventHandler = presenter
        presenter.router = router
    }
}
