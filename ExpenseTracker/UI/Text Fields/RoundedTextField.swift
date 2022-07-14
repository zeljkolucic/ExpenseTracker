//
//  RoundedTextField.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class RoundedTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureLayout()
    }

    private func configureLayout() {
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }

}
