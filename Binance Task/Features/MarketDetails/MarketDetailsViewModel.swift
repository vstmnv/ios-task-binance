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
    private var rows: [MarketDetailsRow] = []

    var title: String { symbol }
    var numberOfRows: Int { rows.count }

    init(symbol: String, apiService: APIService = APIService(baseURL: APIConstants.baseURL)) {
        self.symbol = symbol
        self.apiService = apiService
    }

    // MARK: - Public

    func row(at index: Int) -> MarketDetailsRow? {
        guard rows.indices.contains(index) else {
            return nil
        }
        return rows[index]
    }

    func fetchDetails() async {
        do {
            let response = try await apiService.fetch(SymbolMarketDetailsEndpoint(symbol: symbol))
            rows = makeRows(from: response)
            delegate?.viewModelDidUpdateDetails(self)
        } catch {
            delegate?.viewModel(self, didFailWith: error)
        }
    }

    // MARK: - Private

    private func makeRows(from response: SymbolMarketResponse) -> [MarketDetailsRow] {
        let fields: [(title: String, value: String)] = [
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
            ("Open Time", Date(millisecondsSince1970: response.openTime).marketTimestamp),
            ("Close Time", Date(millisecondsSince1970: response.closeTime).marketTimestamp),
            ("First ID", String(response.firstId)),
            ("Last ID", String(response.lastId)),
            ("Trade Count", String(response.count)),
        ]
        return fields.map { MarketDetailsRow(title: $0.title, value: $0.value) }
    }
}
