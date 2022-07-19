//
//  MainTabBarController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/19/22.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewControllers()
    }
    
    // MARK: - Configuration
    
    private func configureViewControllers() {
        guard let items = tabBar.items, items.count >= 3 else { return }
        
        items[0].title = Strings.statisticsTitle.localized
        items[0].image = UIImage(systemName: SFSymbols.chart)
        
        items[1].title = Strings.transactionsTitle.localized
        items[1].image = UIImage(systemName: SFSymbols.list)
        
        items[2].title = Strings.sharedWithYouTitle.localized
        items[2].image = UIImage(systemName: SFSymbols.folder)
    }

}
