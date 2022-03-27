//
//  DetailAssetPresenter.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

fileprivate struct Asset {
    var asset: AssetModel
    var isFavorite: Bool
}

final class DetailAssetPresenter: DetailAssetOutput,
                                  DetailAssetEventHandler {
    var view: DetailAssetView?
    var dataProvider: DetailAssetDataProvider?
    
    private var asset: Asset?

    func receive(historyPoints: [Double]) {
        let end = historyPoints.count - 1
        let start = end - 287
        if end > start {
            let range = Array(historyPoints[start...end])
            view?.updateChart(with: range)
        } else {
            view?.updateChart(with: historyPoints)
        }
    }
    
    func updateInfo(with asset: AssetModel, isFavorite: Bool) {
        self.asset = Asset(asset: asset, isFavorite: isFavorite)
        let viewModel = DetailAssetInfoViewViewModel(
            title: asset.name,
            priceText: String(format: "%.2f", asset.priceUSD),
            percentText: String(format: "%.2f%%", asset.changePercent),
            percentLabelColor: asset.changePercent < 0 ? .systemRed : .systemGreen,
            infoDictionary: [
                ("Market Cap", String(format: "%.2f", asset.marketCap)),
                ("Supply", String(format: "%.2f", asset.supply)),
                ("Volume (24h)", String(format: "%.2f", asset.volume24h)),
            ],
            isFavorite: isFavorite
        )
        view?.updateAssetInfo(viewModel: viewModel)
    }
    
    func detailAssetInteractor(_ detailAssetInteractor: DetailAssetInteractor, didReceive error: Error) {
        
    }
    
    func detailAssetView(willDisplay view: DetailAssetView) {
        guard let asset = asset else { return }
        dataProvider?.getDetailData(for: asset.asset)
    }
    
    func detailAssetView(didTapFavorite view: DetailAssetView) {
        guard let asset = asset else { return }
        dataProvider?.toggleFavorite(for: asset.asset)
    }
}
