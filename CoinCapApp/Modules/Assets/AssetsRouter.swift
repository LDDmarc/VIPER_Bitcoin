//
//  AssetsRouter.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

final class AssetsRouter: AssetsRouterProtocol {
    var detailAssetModule: DetailAssetModule?
    
    private let userStorage: UserDefaultsStorage
    private let networkService: NetworkService
    
    init(
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        self.userStorage = userStorage
        self.networkService = networkService
    }
    
    func showDetail(for asset: AssetModel, viewController: UIViewController) {
        detailAssetModule = DetailAssetModule(
            asset: asset,
            userStorage: userStorage,
            networkService: networkService
        )
        detailAssetModule?.interactor.getDetailData(for: asset)
        if let detailAssetViewController = detailAssetModule?.view {
            viewController.navigationController?.pushViewController(detailAssetViewController, animated: true)
        }
    }
}
