//
//  CategoryTableViewCell.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 16.9.22..
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    @IBOutlet weak var legendView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    var color: UIColor = .systemBlue {
        didSet {
            legendView.backgroundColor = color
        }
    }
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
