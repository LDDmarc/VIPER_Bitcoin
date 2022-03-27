//
//  CoinCapApi.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import Foundation

enum CoinCapApi {
    case getAssets(model: AssetRequestModel)
    case getBitcoinHistory(model: AssetHistoryRequestModel)
}

extension CoinCapApi: Request {
    var scheme: String {
        "https"
    }
    
    var host: String {
        "api.coincap.io"
    }
    
    var path: String {
        switch self {
        case .getAssets:
            return "/v2/assets"
        case let .getBitcoinHistory(model):
            return "/v2/assets/\(model.id)/history"
        }
    }
    
    var httpMethod: HTTPMethodType {
        switch self {
        case .getAssets, .getBitcoinHistory:
            return .get
        }
    }
    
    var requestModel: RequestModel? {
        switch self {
        case let .getAssets(model):
            return model
        case let .getBitcoinHistory(model):
            return model
        }
    }
    
    var headers: HTTPHeaders? {
//        return ["Accept-Encoding": "gzip"]
        return nil
    }
}
