 //
//  CategoriesViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/21/22.
//

import UIKit

class CategoriesViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndexPath: IndexPath?
    private let reuseIdentifier = "SubcategoryCell"
    
    var viewModel: TransactionDetailViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureTableView()
        
        getSubcategories()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationItem.title = Strings.categoriesTitle.localized
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getSubcategories() {
        viewModel.getSubcategories { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tableView.reloadData()
                    self?.selectedIndexPath = IndexPath(row: .zero, section: .zero)
                    
                case .failure:
                    let title = Strings.errorAlertTitle.localized
                    let actions = [
                        UIAlertAction(title: Strings.ok.localized, style: .default, handler: { _ in
                            self?.navigationController?.popViewController(animated: true)
                        })
                    ]
                    self?.presentAlert(title: title, actions: actions)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        if let selectedIndexPath = selectedIndexPath {
            let subcategory = viewModel.subcategories[selectedIndexPath.row]
            viewModel.transaction.category = subcategory.category
            viewModel.transaction.subcategory = subcategory.name
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Table View Delegate and Data Source

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.subcategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) else {
            return UITableViewCell()
        }
        
        let subcategory = viewModel.subcategories[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = subcategory.name
        cell.contentConfiguration = content
        cell.backgroundColor = .clear
        
        if subcategory.name == viewModel.transaction.subcategory {
            selectedIndexPath = indexPath
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedIndexPath = selectedIndexPath, let previouslySelectedCell = tableView.cellForRow(at: selectedIndexPath), let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        previouslySelectedCell.accessoryType = .none
        selectedCell.accessoryType = .checkmark
        
        self.selectedIndexPath = indexPath
    }
    
}
