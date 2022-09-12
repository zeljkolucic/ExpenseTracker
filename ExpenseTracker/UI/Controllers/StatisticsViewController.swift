//
//  StatisticsViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: StatisticsViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.statisticsTitle.localized
        
        let logOutAction = UIAction(title: Strings.logOut.localized) { [weak self] action in
            self?.logOut()
        }
        let contextMenu = UIMenu(title: "", children: [logOutAction])
        let userImage = UIImage(systemName: SFSymbols.user)
        let userBarButton = UIBarButtonItem(title: nil, image: userImage, primaryAction: nil, menu: contextMenu)
        navigationItem.rightBarButtonItem = userBarButton
    }
    
    private func configureTableView() {
        tableView.register(StatisticsTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc private func logOut() {
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
}

// MARK: - Table View Delegate and Data Source

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(StatisticsTableViewCell.self) else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "Expenses by month"
        cell.descriptionLabel.text = "Check out your expenses based on month"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
