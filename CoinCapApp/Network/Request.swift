//
//  Api.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

protocol Request {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethodType { get }
    var requestModel: RequestModel? { get }
    var headers: HTTPHeaders? { get }
}
