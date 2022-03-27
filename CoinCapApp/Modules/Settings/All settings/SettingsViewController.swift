//
//  SettingsViewController.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

final class SettingsViewController: UIViewController, SettingsView {
    private let settingsTableView = UITableView()
    private let rowHeight: CGFloat = 44.0
    
    private var settings: [AppSettings] = []
    
    weak var eventHandler: SettingsEventsHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupTableView()
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingsTableView)
        NSLayoutConstraint.activate([
            settingsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: CGFloat(settings.count) * rowHeight)
        ])
    }
    
    private func setupTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.rowHeight = rowHeight
        settingsTableView.register(UITableViewCell.self)
    }
    
    func update(settings: [AppSettings]) {
        self.settings = settings
        settingsTableView.reloadData()
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = settings[indexPath.row].desctiption
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        eventHandler?.settingsView(self, didSelectSettingsAt: indexPath.row)
    }
}
