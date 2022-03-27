//
//  UITableView+Extensions.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let identifier = String(describing: type)
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            fatalError("dequeueReusableCell for \(identifier)")
        }
        return cell
    }
    
    func register<T: UITableViewCell>(_ type: T.Type) {
        let identifier = String(describing: type)
        register(type, forCellReuseIdentifier: identifier)
    }
}
