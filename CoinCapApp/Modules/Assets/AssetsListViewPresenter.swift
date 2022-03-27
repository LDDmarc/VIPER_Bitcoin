//
//  ListViewPresenter.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import UIKit

final class AssetsListViewPresenter: ListViewControllerEventHandler,
                                     AssetsInteractorOutput {
    var view: ListView?
    var dataProvider: AssetsListViewDataProvider?
    var router: AssetsRouterProtocol?
    private var assets: [AssetModel] = []
    
    // MARK: AssetsInteractorOutput
    func receiveData(data: [AssetModel]) {
        assets.append(contentsOf: data)
        view?.addData(data.map { convertIntoViewModel($0) })
    }
    
    func updateData(newData: [AssetModel]) {
        assets = newData
        view?.replaceData(with: newData.map { convertIntoViewModel($0) })
    }
    
    func assetsInteractor(_ assetsInteractor: AssetsInteractor, didRecieve error: Error) {
        view?.showError(title: "error_common_title".localized(), message: "internet_error_message".localized())
    }
    
    // MARK: ListViewControllerEventHandler
    func listViewController(pullToRefresh listViewController: ListViewController) {
        dataProvider?.loadAssets(curentAssetsCount: 0)
    }
    
    func listViewController(_ listViewController: ListViewController, didSelectItemAt index: Int) {
        guard let view = view else {
            return
        }

        router?.showDetail(for: assets[index], viewController: view)
    }
    
    func listViewController(_ listViewController: ListViewController, willDisplayLastItem index: Int) {
        dataProvider?.loadAssets(curentAssetsCount: index)
    }
    
    func listViewController(viewWillAppear listViewController: ListViewController) {
        dataProvider?.loadAssets(curentAssetsCount: assets.count)
    }
    
    func listViewController(_ listViewController: ListViewController, deleteItemAt index: Int) {}
    
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

private var currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "USD")
    return formatter
}()
