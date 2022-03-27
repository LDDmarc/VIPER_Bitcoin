//
//  DetailAssetViewController.swift
//  CoinCapApp
//
//  Created by d.leonova on 24.03.2022.
//

import UIKit

typealias DetailAssetInfo = (key: String, value: String)

struct DetailAssetInfoViewViewModel {
    let title: String
    let priceText: String
    let percentText: String
    let percentLabelColor: UIColor
    let infoDictionary: [DetailAssetInfo]
    let isFavorite: Bool
}

// TODO: activity indicator, edges in chart, detail info
final class DetailAssetViewController: UIViewController,
                                       DetailAssetView {
    private let chartView = ChartView()
    private let infoTableView = UITableView()
    private let priceLabel = UILabel()
    private let percentLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView()
    
    private let cellHeight: CGFloat = 44
    private var rightBarButtonIconName = "heart"
    private var infoData = [(key: String, value: String)]()
    
    weak var eventHandler: DetailAssetEventHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        
        setupLabels()
        setupTableView()
        setupNavigationBar()
        
        let views = [
            activityIndicator,
            priceLabel,
            percentLabel,
            chartView,
            infoTableView
        ]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            priceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            percentLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 5),
            percentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 126),
            chartView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            chartView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            chartView.heightAnchor.constraint(equalToConstant: 230),
            
            infoTableView.topAnchor.constraint(equalTo: chartView.bottomAnchor),
            infoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoTableView.heightAnchor.constraint(equalToConstant: CGFloat(infoData.count) * cellHeight) // TODO: depend of row count
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.detailAssetView(willDisplay: self)
    }
    
    private func setupTableView() {
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.alwaysBounceVertical = false
        infoTableView.rowHeight = cellHeight
        infoTableView.register(UITableViewCell.self)
    }
    
    private func setupLabels() {
        priceLabel.font = UIFont.systemFont(ofSize: 64)
        priceLabel.textColor = .black
        
        percentLabel.font = UIFont.systemFont(ofSize: 22)
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: rightBarButtonIconName),
            style: .plain,
            target: self,
            action: #selector(addToFavoritesButtonTap)
        )
    }
    
    @objc
    private func addToFavoritesButtonTap() {
        eventHandler?.detailAssetView(didTapFavorite: self)
    }
    
    func updateChart(with data: [Double]) {
        chartView.update(with: data)
    }
    
    func updateAssetInfo(viewModel: DetailAssetInfoViewViewModel) {
        title = viewModel.title
        rightBarButtonIconName = viewModel.isFavorite ? "heart.fill" : "heart"
        navigationItem.rightBarButtonItem?.image = UIImage(named: rightBarButtonIconName)
        priceLabel.text = viewModel.priceText
        percentLabel.text = viewModel.percentText
        percentLabel.textColor = viewModel.percentLabelColor
        infoData = viewModel.infoDictionary
        infoTableView.reloadData()
    }
}

extension DetailAssetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        infoData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = infoData[indexPath.row].key
        cell.detailTextLabel?.text = infoData[indexPath.row].value
        return cell
    }
}
