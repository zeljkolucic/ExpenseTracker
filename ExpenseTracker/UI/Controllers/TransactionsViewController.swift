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
        
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.transactionsTitle.localized
        
        let shareImage = UIImage(systemName: SFSymbols.share)
        let shareBarButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(didTapShareButton))
        navigationItem.leftBarButtonItem = shareBarButton
        
        
        let logOutAction = UIAction(title: Strings.logOut.localized) { [weak self] action in
            self?.logOut()
        }
        let contextMenu = UIMenu(title: "", children: [logOutAction])
        let userImage = UIImage(systemName: SFSymbols.user)
        let userBarButton = UIBarButtonItem(title: nil, image: userImage, primaryAction: nil, menu: contextMenu)
        navigationItem.rightBarButtonItem = userBarButton
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self)
        
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    @objc private func didTapShareButton() {
        let actionSheet = UIAlertController(title: nil, message: Strings.shareAlertMessage.localized, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: Strings.shareAlertActionTitle.localized, style: .default) { _ in
            
        }
        let exportAction = UIAlertAction(title: Strings.exportAlertActionTitle.localized, style: .default) { _ in
            
        }
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(exportAction)
        
        present(actionSheet, animated: true)
    }
    
    private func logOut() {
        dismiss(animated: true)
    }
    
}

// MARK: - Table View Delegate and Data Source

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
