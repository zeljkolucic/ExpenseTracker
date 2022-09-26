//
//  MainTabBarController.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 27.9.22..
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItems()
    }
    
    private func configureTabBarItems() {
        guard let items = tabBar.items, items.count >= 3 else { return }
                
        items[0].title = Strings.statisticsTitle.localized
        items[1].title = Strings.transactionsTitle.localized
        items[2].title = Strings.sharedWithYouTitle.localized
    }
}
