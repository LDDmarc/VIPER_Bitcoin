//
//  BitcoinHistoryRequestModel.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

enum Interval: String {
    case m1, m5, m15, m30, h1, h2, h6, h12, d1
}

struct AssetHistoryRequestModel: RequestModel {
    let id: String
    let interval: Interval
    let start: Double
    let end: Double
    
    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "interval", value: interval.rawValue),
//            URLQueryItem(name: "start", value: String(start)),
//            URLQueryItem(name: "end", value: String(end)),
        ]
    }
    
    init(
        id: String,
        interval: Interval = .m5
    ) {
        self.id = id
        self.interval = interval
        let now = Date()
        self.start = Date(timeInterval: -(24 * 60 * 60), since: now).timeIntervalSince1970
        self.end = now.timeIntervalSince1970
    }
}
