//
//  MarketListViewModel.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import Foundation

protocol MarketListViewModelDelegate: AnyObject {
    func viewModelDidUpdateList(_ viewModel: MarketListViewModel)
    func viewModel(_ viewModel: MarketListViewModel, didFailWith error: Error)
}

final class MarketListViewModel {
    
    let apiService: APIService
    weak var delegate: MarketListViewModelDelegate?
    
    private var marketData: [SymbolMarketResponse] = []
    private var query: String = ""

    var displayedData: [SymbolMarketResponse] {
        query.isEmpty
            ? marketData
            : marketData.filter { $0.symbol.lowercased().contains(query) }
    }
    
    init(apiService: APIService = APIService(baseURL: APIConstants.baseURL)) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    func fetchMarketData() async {
        do {
            marketData = try await apiService.fetch(SymbolMarketListEndpoint())
            delegate?.viewModelDidUpdateList(self)
        } catch {
            delegate?.viewModel(self, didFailWith: error)
        }
    }
    
    func cellViewModel(for index: Int) -> MarketListCellViewModel? {
        let data = displayedData
        guard data.indices.contains(index) else {
            return nil
        }

        return MarketListCellViewModel(symbolMarketData: data[index])
    }

    func filter(by text: String?) {
        query = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        delegate?.viewModelDidUpdateList(self)
    }
}
