//
//  AppIconSettingsViewController.swift
//  CoinCapApp
//
//  Created by d.leonova on 25.03.2022.
//

import Foundation
import UIKit

final class AppIconSettingsViewController: UIViewController,
                                           AppIconSettingsView {
    private let settingsTableView = UITableView()
    private let rowHeight: CGFloat = 44.0
    
    private var appIcons = [String]()
    private var selectedIndex = 0
    
    weak var eventsHandler: AppIconSettingsEventsHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .never
        
        setupTableView()
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsTableView)
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: CGFloat(appIcons.count) * rowHeight)
        ])
    }
    
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.rowHeight = rowHeight
        settingsTableView.register(UITableViewCell.self)
    }
    
    func update(icons: [String], selectedIndex: Int) {
        appIcons = icons
        self.selectedIndex = selectedIndex
        settingsTableView.reloadData()
    }
}

extension AppIconSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appIcons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = appIcons[indexPath.row]
        cell.accessoryType = selectedIndex == indexPath.row ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        eventsHandler?.iconSettingsView(self, didSelectIconAt: indexPath.row)
    }
}
