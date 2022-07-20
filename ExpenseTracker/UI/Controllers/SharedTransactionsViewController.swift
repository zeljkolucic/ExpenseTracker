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
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Zeljko Lucic"
        
    }
    
    private func configureTableView() {
        tableView.register(TransactionTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Since table view is behind containerView, adding edgeInsets will provide that the most bottom cell is visible
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    private func configureLayout() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.insertSubview(blurEffectView, at: 0)
    }
    
}

// MARK: - Table View Delegate and Data Source

extension SharedTransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionTableViewCell.self) else {
            return UITableViewCell()
        }
        
        cell.categoryLabel.text = "Electricity"
        cell.subcategoryLabel.text = "Utilities"
        cell.dateLabel.text = "Jun 27, 2022"
        cell.valueLabel.text = "-2397.0 RSD"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailTransactionViewController(nibName: "DetailTransactionViewController", bundle: nil)
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
}
