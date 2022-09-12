//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var backgroundLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var signInButton: RoundedButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var registerButton: RoundedButton!
    
    var viewModel: LoginViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        configureBackgroundLabel()
        configureLabels()
        dismissKeyboardWhenTouchOutside()
        configureTextFields()
        
        enterCredentials()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Configuration
    
    private func configureBackgroundLabel() {
        backgroundLabel.textColor = .systemGray4
        backgroundLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 5)
    }
    
    private func enterCredentials() {
        emailTextField.text = "zeljko.lucic99@gmail.com"
        passwordTextField.text = "Testtest123!"
    }
    
    private func configureLabels() {
        welcomeLabel.text = Strings.welcome.localized
        emailTextField.placeholder = Strings.email.localized
        passwordTextField.placeholder = Strings.password.localized
        signInButton.setTitle(Strings.signIn.localized, for: .normal)
        orLabel.text = Strings.or.localized
        registerButton.setTitle(Strings.register.localized, for: .normal)
    }
    
    private func configureTextFields() {
        emailTextField.delegate = self
        emailTextField.returnKeyType = .next
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        
        passwordTextField.delegate = self
        passwordTextField.returnKeyType = .done
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
    }
    
    // MARK: - Actions
    
    @IBAction func didTapSignInButton() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        viewModel.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                let storyboard = UIStoryboard(name: "MainFlow", bundle: .main)
                guard let viewController = storyboard.instantiateViewController(MainTabBarController.self) else { return }
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true)
                
            case .failure(let error):
                let title = Strings.errorAlertTitle.localized
                let message = error.localizedDescription
                let actions = [UIAlertAction(title: Strings.ok.localized, style: .default)]
                self.presentAlert(title: title, message: message, actions: actions)
            }
        }
    }
    
    @IBAction func didTapRegisterButton() {
        let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(FirstStepRegistrationViewController.self) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
