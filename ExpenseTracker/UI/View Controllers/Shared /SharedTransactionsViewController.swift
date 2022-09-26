//
//  SharedTransactionsViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/20/22.
//

import UIKit

class SharedTransactionsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    var viewModel: SharedTransactionsViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureLayout()
        
        getTransactions()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.monthlyTransactionsList.ownerEmail
    }
    
    private func configureTableView() {
        tableView.register(TransactionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Since table view is behind containerView, adding edgeInsets will provide that the most bottom cell is visible
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    private func configureLayout() {
        monthLabel.text = viewModel.monthlyTransactionsList.prettyDateFormatMonth
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.insertSubview(blurEffectView, at: 0)
        
        totalValueLabel.text = String("Total: \(viewModel.monthlyTransactionsList.total)")
    }
    
    private func getTransactions() {
        viewModel.getTransactions { [weak self] result in
            switch result {
            case .success:
                self?.tableView.reloadData()
                
            case .failure:
                break
            }
        }
    }
}

// MARK: - Table View Delegate and Data Source

extension SharedTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionTableViewCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        
        let transaction = viewModel.transactions[indexPath.row]
        cell.categoryLabel.text = transaction.category
        cell.subcategoryLabel.text = transaction.subcategory
        cell.dateLabel.text = transaction.date.convertToDateAndTimeFormatString()
        cell.valueLabel.text = String(transaction.value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "MainFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(DetailTransactionViewController.self) else { return }
        viewController.viewModel.transaction = viewModel.transactions[indexPath.row]
        viewController.state = .view
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
}
