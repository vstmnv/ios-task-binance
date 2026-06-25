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
    @IBOutlet private weak var priceChangeLabel: UILabel!
    @IBOutlet private weak var bidPriceLabel: UILabel!
    @IBOutlet private weak var askPriceLabel: UILabel!
    
    // MARK: - Public
    
    func configure(with viewModel: MarketListCellViewModel) {
        symbolLabel.text = viewModel.symbolMarketData.symbol
        priceChangeLabel.text = viewModel.symbolMarketData.priceChangePercent
        bidPriceLabel.text = viewModel.symbolMarketData.bidPrice
        askPriceLabel.text = viewModel.symbolMarketData.askPrice
    }
}
