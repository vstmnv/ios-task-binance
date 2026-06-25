//
//  MarketListTableViewCell.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import UIKit

final class MarketListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "MarketListTableViewCell"
    
    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var lastPriceLabel: UILabel!
    
    // MARK: - Public
    
    func configure(with viewModel: MarketListCellViewModel) {
        symbolLabel.text = viewModel.symbolMarketData.symbol
        lastPriceLabel.text = viewModel.symbolMarketData.lastPrice
    }
}
