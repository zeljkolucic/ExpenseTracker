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
    
    var viewModel: RegistrationViewModel!
    
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
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .next
        passwordTextField.autocapitalizationType = .none
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        
        passwordConfirmationTextField.delegate = self
        passwordConfirmationTextField.returnKeyType = .done
        passwordConfirmationTextField.autocapitalizationType = .none
        passwordConfirmationTextField.isSecureTextEntry = true
        passwordConfirmationTextField.autocorrectionType = .no
    }
    
    // MARK: - Actions
    
    @objc private func didTapConfirmButton() {
        viewModel.verifySecondStepRegistrationData { [weak self] in
            guard let self = self else { return }
            self.presentAlert(title: Strings.emailSentAlertTitle.localized) { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        } failure: { [weak self] errorMessage in
            guard let self = self else { return }
            self.presentAlert(title: Strings.errorAlertTitle.localized, message: errorMessage)
        }
    }
    
    private func presentAlert(title: String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.ok, style: .default, handler: handler))
        self.present(alertController, animated: true)
    }
    
    
    
}

// MARK: - Text Field Delegate

extension SecondStepRegistrationViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField == emailTextField {
            viewModel.email.value = text
        } else if textField == passwordTextField {
            viewModel.password.value = text
        } else if textField == passwordConfirmationTextField {
            viewModel.passwordConfirmation.value = text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else if textField == passwordConfirmationTextField {
            passwordConfirmationTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
