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
        dismissKeyboardWhenTouchOutside()
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
        let alertController = UIAlertController(title: Strings.emailSentAlertTitle.localized, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Strings.ok, style: .default) { _ in

        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}
