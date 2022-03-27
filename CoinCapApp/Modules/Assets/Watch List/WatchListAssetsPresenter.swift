//
//  WatchListAssetsPresenter.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

final class WatchListAssetsPresenter: WatchListAssetsInteractorOutput,
                                      ListViewControllerEventHandler {
    var view: ListView?
    var dataProvider: WatchListAssetsListViewDataProvider?
    var router: AssetsRouterProtocol?
    private var assets: [AssetModel] = []
    
    func receiveData(data: [AssetModel]) {
        assets = data
        view?.replaceData(with: data.map { convertIntoViewModel($0) })
    }
    
    func listViewController(pullToRefresh listViewController: ListViewController) { }
    
    func listViewController(_ listViewController: ListViewController, didSelectItemAt index: Int) {
        guard let view = view else {
            return
        }

        router?.showDetail(for: assets[index], viewController: view)
    }
    
    func listViewController(_ listViewController: ListViewController, willDisplayLastItem index: Int) { }
    
    func listViewController(viewWillAppear listViewController: ListViewController) {
        dataProvider?.loadFavoriteAssets()
    }
    
    func listViewController(_ listViewController: ListViewController, deleteItemAt index: Int) {
        dataProvider?.deleteAsset(assetId: assets[index].id)
    }
    
    // MARK: Private
    private func convertIntoViewModel(_ asset: AssetModel) -> ListViewCellViewModel {
        let subtitleLabelText = String(format: "%.2f", asset.priceUSD)
        let detailSubtitleLabelText = String(format: "%.2f%%", asset.changePercent)
        let viewModel = ListViewCellViewModel(
            height: 81,
            labelText: asset.symbol,
            subtitleLabelText: asset.name,
            detailTitleLabelText: subtitleLabelText,
            detailSubtitleLabelText: detailSubtitleLabelText,
            detailSubtitleLabelColor: asset.changePercent < 0 ? .systemRed : .systemGreen
        )
        return viewModel
    }
}
