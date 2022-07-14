//
//  TransactionsViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/14/22.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureLabels()
        configureTableView()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.transactionsTitle.localized
        
        let shareImage = UIImage(systemName: SFSymbols.share)
        let shareBarButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(didTapShareButton))
        navigationItem.leftBarButtonItem = shareBarButton
        
        let userImage = UIImage(systemName: SFSymbols.user)
        let userBarButton = UIBarButtonItem(image: userImage, style: .plain, target: self, action: #selector(didTapUserButton))
        navigationItem.rightBarButtonItem = userBarButton
    }
    
    private func configureLabels() {
        
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self)
        
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    @objc private func didTapShareButton() {
        
    }
    
    @objc private func didTapUserButton() {
        
    }
    
}

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionTableViewCell.self) else {
            return UITableViewCell()
        }
        
        cell.transactionImageView.image = UIImage(systemName: "gearshape")
        cell.categoryLabel.text = "Electricity"
        cell.subcategoryLabel.text = "Utilities"
        cell.dateLabel.text = "Jun 27, 2022"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
