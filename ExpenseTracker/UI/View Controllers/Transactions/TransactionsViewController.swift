//
//  TransactionsViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/14/22.
//

import UIKit

class TransactionsViewController: DataLoadingViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    var viewModel: TransactionsViewModel!
    var selectedIndexPath: IndexPath?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.transactionsTitle.localized
        configureNavigationBar()
        configureTableView()
        configureCollectionView()
        configureLayout()
        
        getMonthlyTransactions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationItem.title = Strings.transactionsTitle.localized
        
        let shareImage = UIImage(systemName: SFSymbols.share)
        let shareBarButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(didTapShareButton))
        navigationItem.leftBarButtonItem = shareBarButton
        
        
        let logOutAction = UIAction(title: Strings.signOut.localized) { [weak self] action in
            self?.signOut()
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
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MonthCollectionViewCell.self)
    }
    
    private func selectCollectionViewItem() {
        if let indexPath = selectedIndexPath {
            collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .right)
        }
    }
    
    private func configureLayout() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = containerView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.insertSubview(blurEffectView, at: 0)

        floatingButton.layer.cornerRadius = floatingButton.bounds.width / 2
        floatingButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        floatingButton.layer.shadowOffset = CGSize(width: 4.0, height: 6.0)
        floatingButton.layer.shadowOpacity = 1.0
        floatingButton.layer.shadowRadius = 4.0
        
        // Since table view is behind containerView, adding edgeInsets will provide that the most bottom cell is visible
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
    }
    
    private func getMonthlyTransactions() {
        viewModel.getMonthlyTransactions { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.collectionView.reloadData()
                    
                    if self.selectedIndexPath == nil {
                        let item = self.viewModel.monthlyTransactions.count - 1
                        self.selectedIndexPath = IndexPath(item: item, section: .zero)
                        self.selectCollectionViewItem()
                    }
                    
                    self.getTransactions()
                    
                case .failure:
                    let title = Strings.warningAlertTitle.localized
                    let actions = [
                        UIAlertAction(title: Strings.ok.localized, style: .default)
                    ]
                    self.presentAlert(title: title, actions: actions)
                }
            }
        }
    }
    
    private func getTransactions() {
        presentLoadingView()
        if let selectedIndexPath = selectedIndexPath {
            let monthlyTransactions = viewModel.monthlyTransactions[selectedIndexPath.item]
            totalValueLabel.text = "Total: \(monthlyTransactions.total)"
            
            viewModel.getTransactions(in: monthlyTransactions) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                    
                    switch result {
                    case .success:
                        self.tableView.reloadData()
                        
                        // When new transaction is added, table view is reloaded and monthlyTransactions which the new transaction belongs to is shown, therefore its collection view cell ought to be selected
                        if !self.viewModel.transactions.isEmpty, let transaction = self.viewModel.transactions.first {
                            let month = transaction.date.convertToYearMonthFormat()
                            if let index = self.viewModel.monthlyTransactions.firstIndex(where: { $0.month == month }) {
                                self.selectedIndexPath = IndexPath(row: index, section: 0)
                                self.selectCollectionViewItem()
                            }
                        }
                        
                    case .failure:
                        let title = Strings.warningAlertTitle.localized
                        let actions = [
                            UIAlertAction(title: Strings.ok.localized, style: .default)
                        ]
                        self.presentAlert(title: title, actions: actions)
                    }
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapShareButton() {
        let actionSheet = UIAlertController(title: nil, message: Strings.shareAlertMessage.localized, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: Strings.shareActionSheetTitle.localized, style: .default) { [weak self] _ in
            self?.shareMonthlyTransactionsPrompt()
        }
        let exportAction = UIAlertAction(title: Strings.exportAlertActionTitle.localized, style: .default) { _ in
            
        }
        let cancelAction = UIAlertAction(title: Strings.cancelAlertActionTitle.localized, style: .cancel)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(exportAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)
    }
    
    private func shareMonthlyTransactionsPrompt() {
        let title = Strings.shareAlertTitle.localized
        let message = Strings.shareAlertMessage.localized
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let actions = [
            UIAlertAction(title: Strings.cancelAlertActionTitle.localized, style: .destructive),
            UIAlertAction(title: Strings.ok.localized, style: .default) { [weak self] _ in
                if let textFields = alertController.textFields, let textField = textFields.first, let email = textField.text {
                    self?.shareMonthlyTransactions(withUser: email)
                }
            }
        ]
        
        alertController.addTextField()
        for action in actions {
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
    
    private func shareMonthlyTransactions(withUser email: String) {
        guard let indexPath = selectedIndexPath else { return }
        viewModel.share(monthlyTransactionsIndex: indexPath.row, withUser: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let title = Strings.successfulShareAlertTitle.localized
                let actions = [
                    UIAlertAction(title: Strings.ok.localized, style: .default)
                ]
                self.presentAlert(title: title, actions: actions)
                
            case .failure:
                let title = Strings.warningAlertTitle.localized
                let actions = [
                    UIAlertAction(title: Strings.ok.localized, style: .default)
                ]
                self.presentAlert(title: title, actions: actions)
            }
        }
    }
    
    private func signOut() {
        viewModel.signOut { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.dismiss(animated: true)
                
            case .failure(let error):
                let title = Strings.errorAlertTitle.localized
                let message = error.localizedDescription
                let actions = [UIAlertAction(title: Strings.ok.localized, style: .default)]
                self.presentAlert(title: title, message: message, actions: actions)
            }
        }
    }
    
    @IBAction func didTapFloatingButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "MainFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(DetailTransactionViewController.self) else { return }
        viewController.state = .add
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
}

// MARK: - Table View Delegate and Data Source

extension TransactionsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.valueLabel.text = "\(transaction.value)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "MainFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(DetailTransactionViewController.self) else { return }
        viewController.state = .edit
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        present(navigationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let title = Strings.warningAlertTitle.localized
            let message = Strings.deleteAlertMessage.localized
            let actions = [
                UIAlertAction(title: Strings.cancelAlertActionTitle.localized, style: .default),
                UIAlertAction(title: Strings.yes.localized, style: .destructive)
            ]
            presentAlert(title: title, message: message, actions: actions)
        }
    }
}

// MARK: - Collection View Delegate and Data Source

extension TransactionsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.monthlyTransactions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(MonthCollectionViewCell.self, indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        let monthlyTransactions = viewModel.monthlyTransactions[indexPath.item]
        cell.monthLabel.text = monthlyTransactions.prettyDateFormatMonth
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        getTransactions()
    }
    
}
