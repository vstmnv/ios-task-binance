//
//  Date+Formatting.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 26.06.26.
//

import Foundation

extension Date {
    
    init(millisecondsSince1970 milliseconds: Int) {
        self.init(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    var marketTimestamp: String {
        Self.marketTimestampFormatter.string(from: self)
    }

    private static let marketTimestampFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
}
