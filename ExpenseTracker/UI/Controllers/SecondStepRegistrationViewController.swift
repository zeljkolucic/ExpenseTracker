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
        configureTextFields()
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
    
    private func configureTextFields() {
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .next
        
        passwordConfirmationTextField.delegate = self
        passwordConfirmationTextField.returnKeyType = .done
    }
    
    // MARK: - Actions
    
    @objc private func didTapConfirmButton() {
        let alertController = UIAlertController(title: Strings.emailSentAlertTitle.localized, message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Strings.ok, style: .default) { [weak self] _ in
            self?.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
    }
    
}

// MARK: - Text Field Delegate

extension SecondStepRegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else if textField == passwordConfirmationTextField {
            view.endEditing(true)
        }
        
        return true
    }
    
}
