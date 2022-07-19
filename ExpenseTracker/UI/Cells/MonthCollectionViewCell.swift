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
        backgroundColor = .systemGray3
        layer.cornerRadius = 10
        
        let bgView = UIView()
        bgView.layer.cornerRadius = 10
        bgView.backgroundColor = .systemBlue
        selectedBackgroundView = bgView
    }

}
