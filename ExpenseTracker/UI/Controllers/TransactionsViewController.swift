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
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectCollectionViewLastItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
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
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self)
    }
    
    private func configureCollectionView() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthCollectionViewCell.self)
    }
    
    private func selectCollectionViewLastItem() {
        let indexPath = IndexPath(row: 9, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
    }
    
    // MARK: - Actions
    
    @objc private func didTapShareButton() {
        let actionSheet = UIAlertController(title: nil, message: Strings.shareAlertMessage.localized, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: Strings.shareAlertActionTitle.localized, style: .default) { _ in
            
        }
        let exportAction = UIAlertAction(title: Strings.exportAlertActionTitle.localized, style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: Strings.cancelAlertActionTitle.localized, style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(exportAction)
        actionSheet.addAction(cancelAction)
        
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
        
        cell.categoryLabel.text = "Electricity"
        cell.subcategoryLabel.text = "Utilities"
        cell.dateLabel.text = "Jun 27, 2022"
        cell.valueLabel.text = "-2397.0 RSD"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = DetailTransactionViewController(nibName: "DetailTransactionViewController", bundle: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Collection View Delegate and Data Source

extension TransactionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MonthCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        if indexPath.row % 2 == 0 {
            cell.monthLabel.text = "November 2021"
        } else {
            cell.monthLabel.text = "Jun 2022"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = collectionView.cellForItem(at: indexPath) as? MonthCollectionViewCell else { return }
    }
    
}
