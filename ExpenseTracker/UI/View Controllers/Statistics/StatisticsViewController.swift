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
    
    struct Option {
        let title: String
        let description: String? = nil
        let completion: () -> ()
    }
    
    private lazy var options = [
        Option(title: Strings.expensesByCategory.localized, completion: {
            self.navigateToExpensesByCategories()
        }),
        Option(title: Strings.expensesByMonth.localized, completion: {
            self.navigateToMonthlyExpenses()
        })
    ]
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        title = Strings.statisticsTitle.localized
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = Strings.statisticsTitle.localized
        
        let logOutAction = UIAction(title: Strings.signOut.localized) { [weak self] action in
            self?.signOut()
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
    
    @objc private func signOut() {
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
    
    private func navigateToExpensesByCategories() {
        performSegue(withIdentifier: "StatisticsToExpensesByCategorySegue", sender: nil)
    }
    
    private func navigateToMonthlyExpenses() {
        performSegue(withIdentifier: "StatisticsToMonthlyExpensesSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatisticsToExpensesByCategorySegue", let viewController = segue.destination as? ExpensesByCategoryViewController {
            viewController.viewModel = viewModel
        } else if segue.identifier == "StatisticsToMonthlyExpensesSegue", let viewController = segue.destination as? MonthlyExpensesViewController {
            viewController.viewModel = viewModel
        }
    }
}

// MARK: - Table View Delegate and Data Source

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(StatisticsTableViewCell.self, at: indexPath) else {
            return UITableViewCell()
        }
        
        let option = options[indexPath.row]
        cell.titleLabel.text = option.title
        cell.descriptionLabel.text = option.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        option.completion()
    }
    
}
