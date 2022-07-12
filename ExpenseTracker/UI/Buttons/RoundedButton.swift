//
//  RoundedButton.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        layer.cornerRadius = 5
    }
    
}
