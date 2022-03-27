//
//  AssetModel.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import Foundation

struct AssetModel {
    let id: String
    let symbol: String
    let name: String
    let priceUSD: Double
    let changePercent: Double
    let marketCap: Double
    let supply: Double
    let volume24h: Double
    
    init(responseModel: AssetResponseModel) {
        self.id = responseModel.id
        self.symbol = responseModel.symbol
        self.name = responseModel.name
        self.priceUSD = Double(responseModel.priceUsd) ?? 0
        self.changePercent = Double(responseModel.changePercent24Hr) ?? 0
        self.marketCap = Double(responseModel.marketCapUsd) ?? 0
        self.supply = Double(responseModel.supply) ?? 0
        self.volume24h = Double(responseModel.volumeUsd24Hr) ?? 0
    }
}
