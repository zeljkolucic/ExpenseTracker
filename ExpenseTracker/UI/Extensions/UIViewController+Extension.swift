//
//  UIViewController+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

extension UIViewController {
    
    func dismissKeyboardWhenTouchOutside() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTouchOutsideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func didTouchOutsideKeyboard() {
        view.endEditing(true)
    }
    
    func presentAlert(title: String, message: String? = nil, actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        present(alertController, animated: true)
    }
    
}
