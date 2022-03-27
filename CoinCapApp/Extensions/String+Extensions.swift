//
//  String+Extensions.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, comment: "")
    }
}
