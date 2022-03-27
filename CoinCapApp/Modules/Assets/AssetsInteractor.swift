//
//  AssetsInteractor.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import Foundation

final class AssetsInteractor: AssetsListViewDataProvider {
    private let networkService: NetworkService
    
    weak var output: AssetsInteractorOutput?
    
    init(
        networkService: NetworkService
    ) {
        self.networkService = networkService
    }
    
    func loadAssets(curentAssetsCount: Int) {
    let requestModel = AssetRequestModel(offset: curentAssetsCount)
        networkService.request(
            CoinCapApi.getAssets(model: requestModel)
        ) { (result: Result<ResponseContainer<[AssetResponseModel]>, NetworkError>) in
            do {
                let models = try result.get().data
                let newData = models.map { AssetModel(responseModel: $0) }
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    if curentAssetsCount == 0 {
                        self.output?.updateData(newData: newData)
                    } else {
                        self.output?.receiveData(data: newData)
                    }
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self else { return }
                    self.output?.assetsInteractor(self, didRecieve: error)
                }
            }
        }
    }
}
