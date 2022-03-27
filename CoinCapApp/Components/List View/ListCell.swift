//
//  ListCell.swift
//  CoinCapApp
//
//  Created by d.leonova on 23.03.2022.
//

import UIKit

struct ListViewCellViewModel: Equatable {
    let height: CGFloat
    let labelText: String
    let subtitleLabelText: String
    let detailTitleLabelText: String
    let detailSubtitleLabelText: String
    let detailSubtitleLabelColor: UIColor
    
    let id = UUID()
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

final class ListCell: UITableViewCell {
    private var viewModel: ListViewCellViewModel?
    
    private let itemImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let detailTitleLabel = UILabel()
    private let detailSubtitleLabel = UILabel()
    
    init() {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .white
        
        setupLabels()
        
        let views = [
            itemImageView,
            titleLabel,
            subtitleLabel,
            detailTitleLabel,
            detailSubtitleLabel
        ]
        views.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        views.forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            itemImageView.widthAnchor.constraint(equalToConstant: 60),
            itemImageView.heightAnchor.constraint(equalToConstant: 60),
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            itemImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 15),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3.5),
            subtitleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 15),
            
            detailTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            detailTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            
            detailSubtitleLabel.topAnchor.constraint(equalTo: detailTitleLabel.bottomAnchor, constant: 7),
            detailSubtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
        ])
        
        detailTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailSubtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private func setupLabels() {
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .black
        
        subtitleLabel.font = .preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .gray
        
        detailSubtitleLabel.font = .preferredFont(forTextStyle: .headline)
        detailSubtitleLabel.textColor = .gray
        
        detailSubtitleLabel.font = .preferredFont(forTextStyle: .caption1)
    }
    
    func configure(with viewModel: ListViewCellViewModel) {
        self.viewModel = viewModel
        
        titleLabel.text = viewModel.labelText
        subtitleLabel.text = viewModel.subtitleLabelText
        detailTitleLabel.text = viewModel.detailTitleLabelText
        detailSubtitleLabel.text = viewModel.detailSubtitleLabelText
        detailSubtitleLabel.textColor = viewModel.detailSubtitleLabelColor
    }
}
