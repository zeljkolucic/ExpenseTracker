//
//  SecondStepRegistrationViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class SecondStepRegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var passwordConfirmationTextField: RoundedTextField!
    @IBOutlet weak var confirmButton: RoundedButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureLabels()
        defineActions()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        navigationItem.title = Strings.registration.localized
        emailTextField.placeholder = Strings.email.localized
        passwordTextField.placeholder = Strings.password.localized
        passwordConfirmationTextField.placeholder = Strings.passwordConfirmation.localized
        confirmButton.setTitle(Strings.confirm.localized, for: .normal)
    }
    
    private func defineActions() {
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func didTapConfirmButton() {
        
    }
    
}
