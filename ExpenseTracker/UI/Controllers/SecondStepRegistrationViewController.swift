//
//  SecondStepRegistrationViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class SecondStepRegistrationViewController: UIViewController {
    
    // MARK: - Layout
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var passwordConfirmationTextField: RoundedTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureLabels()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        navigationItem.title = Strings.registration.localized
        emailTextField.placeholder = Strings.email.localized
        passwordTextField.placeholder = Strings.password.localized
        passwordConfirmationTextField.placeholder = Strings.passwordConfirmation.localized
        confirmButton.setTitle(Strings.confirm.localized, for: .normal)
    }
    
}
