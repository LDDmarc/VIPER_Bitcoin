//
//  DetailAssetModule.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

protocol DetailAssetEventHandler: AnyObject {
    func detailAssetView(didTapFavorite view: DetailAssetView)
    func detailAssetView(willDisplay view: DetailAssetView)
}

protocol DetailAssetOutput: AnyObject {
    func receive(historyPoints: [Double])
    func updateInfo(with asset: AssetModel, isFavorite: Bool)
    func detailAssetInteractor(_ detailAssetInteractor: DetailAssetInteractor, didReceive error: Error)
}

protocol DetailAssetDataProvider {
    func getDetailData(for asset: AssetModel)
    func toggleFavorite(for asset: AssetModel)
}

protocol DetailAssetView {
    func updateAssetInfo(viewModel: DetailAssetInfoViewViewModel)
    func updateChart(with data: [Double])
}

final class DetailAssetModule {
    let asset: AssetModel
    let interactor: DetailAssetInteractor
    let presenter: DetailAssetPresenter
    let view: DetailAssetViewController
    
    init(
        asset: AssetModel,
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        self.asset = asset
        
        interactor = DetailAssetInteractor(
            userStorage: userStorage,
            networkService: networkService
        )
        presenter = DetailAssetPresenter()
        view = DetailAssetViewController()
        
        interactor.output = presenter
        presenter.dataProvider = interactor
        presenter.view = view
        view.eventHandler = presenter
        
        interactor.getDetailData(for: asset)
    }
}
