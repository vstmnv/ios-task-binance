//
//  MarketDetailsTableViewCell.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 26.06.26.
//

import UIKit

final class MarketDetailsTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "MarketDetailsTableViewCell"
    
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    func configure(with row: MarketDetailsRow) {
        keyLabel.text = row.title
        valueLabel.text = row.value
    }
}
