//
//  AssetResponseModel.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

struct AssetResponseModel: Decodable {
    let id: String
    let name: String
    let symbol: String
    let priceUsd: String
    let changePercent24Hr: String
    let marketCapUsd: String
    let volumeUsd24Hr: String
    let supply: String
}
