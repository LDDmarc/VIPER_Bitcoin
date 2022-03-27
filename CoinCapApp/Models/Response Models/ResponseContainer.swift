//
//  ResponseContainer.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

class ResponseContainer<Model: Decodable>: Decodable {
    var data: Model
}
