//
//  AssetRequestModel.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

struct AssetRequestModel: RequestModel {
    let limit: Int
    let offset: Int
    let ids: [String]?
    
    var queryItems: [URLQueryItem]? {
        var items = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset)),
        ]
        
        if let ids = ids {
            let searchItem = URLQueryItem(name: "ids", value: ids.joined(separator: ","))
            items.insert(searchItem, at: 0)
        }
        
        return items
    }
    
    init(
        limit: Int = 10,
        offset: Int,
        ids: [String]? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.ids = ids
    }
}
