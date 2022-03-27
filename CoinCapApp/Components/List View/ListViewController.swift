//
//  ListViewController.swift
//  CoinCapApp
//
//  Created by d.leonova on 22.03.2022.
//

import UIKit

protocol ListViewControllerEventHandler: AnyObject {
    func listViewController(pullToRefresh listViewController: ListViewController)
    func listViewController(_ listViewController: ListViewController, didSelectItemAt index: Int)
    func listViewController(_ listViewController: ListViewController, willDisplayLastItem index: Int)
    func listViewController(_ listViewController: ListViewController, deleteItemAt index: Int)
    func listViewController(viewWillAppear listViewController: ListViewController)
}

protocol ListView: UIViewController {
    func replaceData(with newData: [ListViewCellViewModel])
    func addData(_ newData: [ListViewCellViewModel])
    func showError(title: String, message: String)
}

//TODO: Empty screen

final class ListViewController: UITableViewController,
                                ListView {
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var data: [ListViewCellViewModel] = []
    private var filteredData: [ListViewCellViewModel] {
        if let filter = filter,
           !filter.isEmpty {
            return data.filter { $0.labelText.contains(filter) || $0.subtitleLabelText.contains(filter) }
        }
        return data
    }
    private var filter: String?
    
    weak var eventHandler: ListViewControllerEventHandler?
    
    var searchBarIsHidden = false {
        didSet {
            searchController.searchBar.isHidden = searchBarIsHidden
        }
    }
    var pullToRefreshIsEnabled = true {
        didSet {
            setupPullToRefresh()
        }
    }
    var deletingRowsIsEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(ListCell.self)
        setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.listViewController(viewWillAppear: self)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false // TODO: obscuresBackgroundDuringPresentation
        searchController.searchBar.placeholder = "search_bar_placeholder".localized()
        navigationItem.searchController = searchController
        setupPullToRefresh()
        searchController.searchBar.isHidden = searchBarIsHidden
    }
    
    private func setupPullToRefresh() {
        if pullToRefreshIsEnabled {
            refreshControl = UIRefreshControl()
            refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            refreshControl?.isHidden = !pullToRefreshIsEnabled
        } else {
            refreshControl = nil
        }
    }
    
    @objc
    private func pullToRefresh() {
        eventHandler?.listViewController(pullToRefresh: self)
    }
    
    func replaceData(with newData: [ListViewCellViewModel]) {
        assert(Thread.isMainThread)
        refreshControl?.endRefreshing()
        data = newData
        tableView.reloadData()
    }
    
    func addData(_ newData: [ListViewCellViewModel]) {
        assert(Thread.isMainThread)
        refreshControl?.endRefreshing()
        guard !newData.isEmpty else { return }
        
        let startRow = filteredData.count
        data.append(contentsOf: newData)
        let endRow = filteredData.count - 1
        guard endRow >= startRow else { return }
        let indexPathRange = Array(startRow...endRow).map { IndexPath(row: $0, section: 0) }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPathRange, with: .automatic)
        tableView.endUpdates()
    }
    
    func showError(title: String, message: String) {
        assert(Thread.isMainThread)
        refreshControl?.endRefreshing()
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok_common".localized(), style: .cancel))
        present(alertController, animated: true)
    }
    
// MARK: UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ListCell.self, for: indexPath)
        let model = filteredData[indexPath.row]
        cell.configure(with: model)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let itemIndex = data.firstIndex(of: filteredData[indexPath.row]) {
            eventHandler?.listViewController(self, didSelectItemAt: itemIndex)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        filteredData[indexPath.row].height
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == filteredData.count - 1 {
            eventHandler?.listViewController(self, willDisplayLastItem: data.count)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        deletingRowsIsEnabled
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        if let itemIndex = data.firstIndex(of: filteredData[indexPath.row]) {
            data.remove(at: itemIndex)
            tableView.deleteRows(at: [IndexPath(row: itemIndex, section: 0)], with: .fade)
            eventHandler?.listViewController(self, deleteItemAt: itemIndex)
        }
    }
}

// MARK: UISearchResultsUpdating
extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filter = searchController.searchBar.text
        tableView.reloadData()
    }
}
