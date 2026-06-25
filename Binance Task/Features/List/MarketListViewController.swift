//
//  MarketListViewController.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import UIKit

final class MarketListViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    
    private let viewModel = MarketListViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        
        setupTableView()
        setupSearchBar()
        fetchData()
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.keyboardDismissMode = .onDrag
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
    }
    
    @objc private func fetchData() {
        Task {
            await viewModel.fetchMarketData()
        }
    }
}

// MARK: - UITableViewDataSource

extension MarketListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.displayedData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let marketCell = tableView.dequeueReusableCell(withIdentifier: MarketListTableViewCell.reuseIdentifier)
        let marketCellViewModel = viewModel.cellViewModel(for: indexPath.row)
        
        guard let marketCell = marketCell as? MarketListTableViewCell, let marketCellViewModel else {
            return UITableViewCell()
        }
        
        marketCell.configure(with: marketCellViewModel)
        return marketCell
    }
}

// MARK: - UITableViewDelegate

extension MarketListViewController: UITableViewDelegate {
    
}

// MARK: - UISearchBarDelegate

extension MarketListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(by: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        viewModel.filter(by: nil)
    }
}

// MARK: - MarketListViewModelDelegate

extension MarketListViewController: MarketListViewModelDelegate {
    func viewModelDidUpdateList(_ viewModel: MarketListViewModel) {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }

    func viewModel(_ viewModel: MarketListViewModel, didFailWith error: Error) {
        tableView.refreshControl?.endRefreshing()
        let alert = UIAlertController(
            title: "Couldn’t load market data",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
