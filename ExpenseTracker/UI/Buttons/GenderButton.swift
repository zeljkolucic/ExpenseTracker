//
//  GenderButton.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class GenderButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }
    
    private func configureLayout() {
        layer.cornerRadius = 8
        layer.borderWidth = 0.7
        layer.borderColor = UIColor.lightGray.cgColor
    }

}
