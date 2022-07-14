//
//  TransactionTableViewCell.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/14/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var transactionImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        transactionImageView.contentMode = .scaleAspectFit
    }
    
}
