//
//  MarketDetailsViewController.swift
//  Binance Task
//
//  Created by Vesela Stamenova on 25.06.26.
//

import UIKit

final class MarketDetailsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var lastUpdatedLabel: UILabel!
    
    private let viewModel: MarketDetailsViewModel

    // MARK: - Init

    init?(coder: NSCoder, viewModel: MarketDetailsViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Use init(coder:viewModel:)")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.symbol
        viewModel.delegate = self
        activityIndicator.startAnimating()
        
        setupTableView()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Private
    
    private func setupTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(fetchData), for: .valueChanged)
    }
    
    @objc private func fetchData() {
        Task {
            await viewModel.fetchDetails()
            activityIndicator.stopAnimating()
        }
    }
}

// MARK: - UITableViewDataSource

extension MarketDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailsCell = tableView.dequeueReusableCell(withIdentifier: MarketDetailsTableViewCell.reuseIdentifier)
        let row = viewModel.row(at: indexPath.row)

        guard let detailsCell = detailsCell as? MarketDetailsTableViewCell, let row else {
            return UITableViewCell()
        }

        detailsCell.configure(with: row)
        return detailsCell
    }
}

// MARK: - MarketDetailsViewModelDelegate

extension MarketDetailsViewController: MarketDetailsViewModelDelegate {
    func viewModelDidUpdateDetails(_ viewModel: MarketDetailsViewModel) {
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
        lastUpdatedLabel.text = viewModel.lastUpdatedLabel
    }
}
