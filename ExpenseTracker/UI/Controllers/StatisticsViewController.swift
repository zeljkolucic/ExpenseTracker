//
//  StatisticsViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
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
    
    // MARK: - Actions
    
    @objc private func logOut() {
        dismiss(animated: true)
    }
}
