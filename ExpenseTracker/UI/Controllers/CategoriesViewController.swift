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
    
    var selectedIndexPath: IndexPath!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndexPath = IndexPath(row: 0, section: 0)

        configureNavigationBar()
        configureTableView()
    }
    
    // MARK: - Configuration
    
    private func configureNavigationBar() {
        navigationItem.title = Strings.categoriesTitle.localized
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        navigationItem.rightBarButtonItem = doneBarButton
    }
    
    private func configureTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubcategoryCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc private func didTapDoneButton() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Table View Delegate and Data Source

extension CategoriesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SubcategoryCell") else {
            return UITableViewCell()
        }
        
        var content = cell.defaultContentConfiguration()
        content.image = UIImage(systemName: "star")
        content.text = "Subcategory"
        cell.contentConfiguration = content
        
        if selectedIndexPath == indexPath {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let previouslySelectedCell = tableView.cellForRow(at: selectedIndexPath), let selectedCell = tableView.cellForRow(at: indexPath) else { return }
        
        previouslySelectedCell.accessoryType = .none
        selectedCell.accessoryType = .checkmark
        
        selectedIndexPath = indexPath
    }
    
}
