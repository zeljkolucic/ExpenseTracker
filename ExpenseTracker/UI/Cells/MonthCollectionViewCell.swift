//
//  MonthCollectionViewCell.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

class MonthCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var monthLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureLayout()
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray3
    }
    
    func select() {
        contentView.backgroundColor = .systemBlue
    }
    
    func deselect() {
        contentView.backgroundColor = .systemGray3
    }

}
