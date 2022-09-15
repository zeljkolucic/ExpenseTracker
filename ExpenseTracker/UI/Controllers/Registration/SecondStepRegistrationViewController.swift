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
    
    @IBAction func didTapConfirmButton() {
        viewModel.verifySecondStepRegistrationData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.navigationController?.popToRootViewController(animated: true)
                
            case .failure(let error):
                let title = Strings.errorAlertTitle.localized
                let message = error.localizedDescription.localized
                let actions = [UIAlertAction(title: Strings.ok.localized, style: .default)]
                self.presentAlert(title: title, message: message, actions: actions)
            }
        }
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
