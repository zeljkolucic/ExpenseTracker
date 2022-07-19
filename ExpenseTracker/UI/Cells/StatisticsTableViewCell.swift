//
//  StatisticsTableViewCell.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/19/22.
//

import UIKit

class StatisticsTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.4) {
            self.containerView.backgroundColor = .systemGray3
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.4) {
            self.containerView.backgroundColor = .systemGray4
        }
        
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        selectionStyle = .none
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .systemGray4
    }
    
    
}
