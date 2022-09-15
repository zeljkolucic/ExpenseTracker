//
//  SharedWithYouViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class SharedWithYouViewController: DataLoadingViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SharedWithYouViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Strings.sharedWithYouTitle.localized
        configureNavigationBar()
        configureTableView()
        
        getSharedMonthlyTransactions()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = Strings.sharedWithYouTitle.localized
        
        let logOutAction = UIAction(title: Strings.signOut.localized) { [weak self] action in
            self?.signOut()
        }
        let contextMenu = UIMenu(title: "", children: [logOutAction])
        let userImage = UIImage(systemName: SFSymbols.user)
        let userBarButton = UIBarButtonItem(title: nil, image: userImage, primaryAction: nil, menu: contextMenu)
        navigationItem.rightBarButtonItem = userBarButton
    }
    
    private func configureTableView() {
        tableView.register(TransactionsListTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    private func signOut() {
        viewModel.signOut { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.dismiss(animated: true)
                
            case .failure(let error):
                let alertController = UIAlertController(title: Strings.errorAlertTitle.localized, message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.ok.localized, style: .default))
                self.present(alertController, animated: true)
            }
        }
    }
    
    func getSharedMonthlyTransactions() {
        presentLoadingView()
        viewModel.getSharedMonthlyTransactions { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
                
                switch result {
                case .success:
                    self.tableView.reloadData()
                    
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

// MARK: - Table View Delegate and Data Source

extension SharedWithYouViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.monhtlyTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionsListTableViewCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        
        let monthlyTransactionsList = viewModel.monhtlyTransactions[indexPath.row]
        cell.userLabel.text = monthlyTransactionsList.ownerName
        cell.monthLabel.text = monthlyTransactionsList.prettyDateFormatMonth
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "MainFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(SharedTransactionsViewController.self) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
}
