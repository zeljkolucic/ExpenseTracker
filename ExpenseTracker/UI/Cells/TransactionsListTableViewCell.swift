//
//  TransactionsListTableViewCell.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class TransactionsListTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        accessoryType = .disclosureIndicator
    }
    
}
