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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var lastUpdatedLabel: UILabel!
    
    private let viewModel = MarketListViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        activityIndicator.startAnimating()
        
        setupTableView()
        setupSearchBar()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
            activityIndicator.stopAnimating()
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let symbolMarketData = viewModel.symbolMarketData(at: indexPath.row) else {
            return
        }

        let storyboard = UIStoryboard(name: "MarketDetails", bundle: nil)
        let detailsViewController = storyboard.instantiateInitialViewController { coder in
            MarketDetailsViewController(
                coder: coder,
                viewModel: MarketDetailsViewModel(symbolMarketData: symbolMarketData)
            )
        }
        
        guard let detailsViewController else {
            return
        }

        navigationController?.pushViewController(detailsViewController, animated: true)
    }
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
        lastUpdatedLabel.text = viewModel.lastUpdatedLabel
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
