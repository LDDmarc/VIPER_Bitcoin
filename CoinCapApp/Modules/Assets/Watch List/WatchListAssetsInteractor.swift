//
//  WatchListAssetsInteractor.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import Foundation

final class WatchListAssetsInteractor: WatchListAssetsListViewDataProvider {
    private let userStorage: UserDefaultsStorage
    private let networkService: NetworkService
    
    weak var output: WatchListAssetsInteractorOutput?
    
    init(
        userStorage: UserDefaultsStorage,
        networkService: NetworkService
    ) {
        self.userStorage = userStorage
        self.networkService = networkService
    }
    
    func loadFavoriteAssets() {
        guard !userStorage.favoritesIds.isEmpty else {
            output?.receiveData(data: [])
            return
        }
        
        let requestModel = AssetRequestModel(offset: 0, ids: userStorage.favoritesIds)
        networkService.request(
            CoinCapApi.getAssets(model: requestModel)
        ) { (result: Result<ResponseContainer<[AssetResponseModel]>, NetworkError>) in
            do {
                let models = try result.get().data
                let newData = models.map { AssetModel(responseModel: $0) }
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.output?.receiveData(data: newData)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
//                    self.output?
                    // TODO: error
                }
            }
        }
    }
    
    func deleteAsset(assetId: String) {
        userStorage.toggleFavoriteForAsset(assetId: assetId)
        loadFavoriteAssets()
    }
}
