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
        title = viewModel.title
        viewModel.delegate = self
        activityIndicator.startAnimating()
        Task {
            await viewModel.fetchDetails()
            activityIndicator.stopAnimating()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UITableViewDataSource

extension MarketDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let detailsCell = tableView.dequeueReusableCell(withIdentifier: MarketDetailsTableViewCell.reuseIdentifier)
        let detailsCellViewModel = viewModel.cellViewModel(for: indexPath.row)

        guard let detailsCell = detailsCell as? MarketDetailsTableViewCell, let detailsCellViewModel else {
            return UITableViewCell()
        }

        detailsCell.configure(with: detailsCellViewModel)
        return detailsCell
    }
}

// MARK: - MarketDetailsViewModelDelegate

extension MarketDetailsViewController: MarketDetailsViewModelDelegate {
    func viewModelDidUpdateDetails(_ viewModel: MarketDetailsViewModel) {
        tableView.reloadData()
    }

    func viewModel(_ viewModel: MarketDetailsViewModel, didFailWith error: Error) {
        let alert = UIAlertController(
            title: "Couldn't load details",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
