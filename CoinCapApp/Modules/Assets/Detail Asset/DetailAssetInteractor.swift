//
//  DetailAssetInteractor.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

final class DetailAssetInteractor: DetailAssetDataProvider {
    private let userStorage: UserDefaultsStorage
    private let networkService: NetworkService
    weak var output: DetailAssetOutput?
    
    init(
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        self.userStorage = userStorage
        self.networkService = networkService
    }
    
    func getDetailData(for asset: AssetModel) {
        output?.updateInfo(with: asset, isFavorite: userStorage.isFavoriteAsset(assetId: asset.id))
        
        let requestModel = AssetHistoryRequestModel(id: asset.id, interval: .m5)
        networkService.request(
            CoinCapApi.getBitcoinHistory(model: requestModel)
        ) { (result: Result<ResponseContainer<[AssetHistoryResponseModel]>, NetworkError>) in
            do {
                let models = try result.get().data
                let newData = models.compactMap { Double($0.priceUsd) }
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.output?.receive(historyPoints: newData)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.output?.detailAssetInteractor(self, didReceive: error)
                }
            }
        }
    }
    
    func toggleFavorite(for asset: AssetModel) {
        userStorage.toggleFavoriteForAsset(assetId: asset.id)
        output?.updateInfo(with: asset, isFavorite: userStorage.isFavoriteAsset(assetId: asset.id))
    }
}
