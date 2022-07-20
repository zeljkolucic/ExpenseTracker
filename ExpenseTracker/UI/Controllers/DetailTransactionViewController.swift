//
//  DetailTransactionViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class DetailTransactionViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureTableView()
    }

    // MARK: - Configuration
    
    private func configureNavigationBar() {
        let closeBarButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancelButton))
        navigationItem.leftBarButtonItem = closeBarButton
        
        let editImage = UIImage(systemName: SFSymbols.edit)
        let editBarButton = UIBarButtonItem(image: editImage, style: .plain, target: self, action: #selector(didTapEditButton))
        
        let deleteImage = UIImage(systemName: SFSymbols.delete)
        let deleteBarButton = UIBarButtonItem(image: deleteImage, style: .plain, target: self, action: #selector(didTapDeleteButton))
        deleteBarButton.tintColor = .systemRed
        
        navigationItem.rightBarButtonItems = [deleteBarButton, editBarButton]
    }
    
    private func configureTableView() {
        tableView.separatorColor = .lightGray
        tableView.isScrollEnabled = false
        tableView.register(TransactionDetailTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapEditButton() {
        
    }
    
    @objc private func didTapDeleteButton() {
        let alertController = UIAlertController(title: Strings.warningAlertTitle.localized, message: Strings.deleteAlertMessage.localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.no.localized, style: .cancel))
        alertController.addAction(UIAlertAction(title: Strings.yes.localized, style: .destructive) { [weak self] _ in
            alertController.dismiss(animated: true)
            self?.navigationController?.popViewController(animated: true)
        })
        present(alertController, animated: true)
    }

}

// MARK: - Table View Delegate and Data Source

extension DetailTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(TransactionDetailTableViewCell.self) else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "Category"
        cell.subtitleLabel.text = "Utilities"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
