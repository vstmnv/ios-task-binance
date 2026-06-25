//
//  MarketDetailsViewModel.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

protocol MarketDetailsViewModelDelegate: AnyObject {
    func viewModelDidUpdateDetails(_ viewModel: MarketDetailsViewModel)
    func viewModel(_ viewModel: MarketDetailsViewModel, didFailWith error: Error)
}

final class MarketDetailsViewModel {

    let symbol: String
    weak var delegate: MarketDetailsViewModelDelegate?

    private let apiService: APIService
    private var rows: [MarketDetailsCellViewModel] = []

    var title: String { symbol }
    var numberOfRows: Int { rows.count }

    init(symbol: String, apiService: APIService = APIService(baseURL: APIConstants.baseURL)) {
        self.symbol = symbol
        self.apiService = apiService
    }

    // MARK: - Public

    func cellViewModel(for index: Int) -> MarketDetailsCellViewModel? {
        guard rows.indices.contains(index) else {
            return nil
        }
        return rows[index]
    }

    func fetchDetails() async {
        do {
            let response = try await apiService.fetch(SymbolMarketDetailsEndpoint(symbol: symbol))
            rows = Self.makeRows(from: response)
            delegate?.viewModelDidUpdateDetails(self)
        } catch {
            delegate?.viewModel(self, didFailWith: error)
        }
    }

    // MARK: - Private

    private static func makeRows(from response: SymbolMarketResponse) -> [MarketDetailsCellViewModel] {
        let fields: [(label: String, value: String)] = [
            ("Symbol", response.symbol),
            ("Price Change", response.priceChange),
            ("Price Change %", response.priceChangePercent),
            ("Weighted Avg Price", response.weightedAvgPrice),
            ("Previous Close", response.prevClosePrice),
            ("Last Price", response.lastPrice),
            ("Last Quantity", response.lastQty),
            ("Bid Price", response.bidPrice),
            ("Bid Quantity", response.bidQty),
            ("Ask Price", response.askPrice),
            ("Ask Quantity", response.askQty),
            ("Open Price", response.openPrice),
            ("High Price", response.highPrice),
            ("Low Price", response.lowPrice),
            ("Volume", response.volume),
            ("Quote Volume", response.quoteVolume),
            ("Open Time", String(response.openTime)),
            ("Close Time", String(response.closeTime)),
            ("First ID", String(response.firstId)),
            ("Last ID", String(response.lastId)),
            ("Trade Count", String(response.count)),
        ]
        return fields.map { MarketDetailsCellViewModel(key: $0.label, value: $0.value) }
    }
}
