//
//  RequestModel.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import Foundation

protocol RequestModel {
    var queryItems: [URLQueryItem]? { get }
}
