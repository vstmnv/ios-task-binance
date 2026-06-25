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
    private var lastUpdatedDate: Date?
    private var query: String = ""

    var displayedData: [SymbolMarketResponse] {
        query.isEmpty
            ? marketData
            : marketData.filter { $0.symbol.lowercased().contains(query) }
    }
    
    var lastUpdatedLabel: String {
        guard let lastUpdatedDate else {
            return ""
        }
        
        return "Last updated: \(lastUpdatedDate.formatted(date: .abbreviated, time: .complete))"
    }
    
    init(apiService: APIService = APIService(baseURL: APIConstants.baseURL)) {
        self.apiService = apiService
    }
    
    // MARK: - Public
    
    func fetchMarketData() async {
        do {
            marketData = try await apiService.fetch(SymbolMarketListEndpoint())
            lastUpdatedDate = Date()
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

    func symbolMarketData(at index: Int) -> SymbolMarketResponse? {
        let data = displayedData
        guard data.indices.contains(index) else {
            return nil
        }
        return data[index]
    }

    func filter(by text: String?) {
        query = (text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        delegate?.viewModelDidUpdateList(self)
    }
}
