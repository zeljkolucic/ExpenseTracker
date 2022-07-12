//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var signInButton: RoundedButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var registerButton: RoundedButton!
    
    private lazy var backgroundLabel: UILabel = {
        let label = UILabel()
        label.text = "E"
        label.textColor = .systemGray4
        label.font = .systemFont(ofSize: 850, weight: .black)
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel = LoginViewModel()
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        configureLayout()
        configureLabels()
        defineActions()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - Configuration
    
    private func configureLayout() {
        view.addSubview(backgroundLabel)
        view.sendSubviewToBack(backgroundLabel)
    }
    
    private func configureLabels() {
        welcomeLabel.text = Strings.welcome.localized
        emailTextField.placeholder = Strings.email.localized
        passwordTextField.placeholder = Strings.password.localized
        signInButton.setTitle(Strings.signIn.localized, for: .normal)
        orLabel.text = Strings.or.localized
        registerButton.setTitle(Strings.register.localized, for: .normal)
    }
    
    private func defineActions() {
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
    }
    
    private func bind() {
        
    }
    
    // MARK: - Actions
    
    @objc private func didTapSignInButton() {
        
    }
    
    @objc private func didTapRegisterButton() {
        let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "FirstStepRegistrationViewController") as? FirstStepRegistrationViewController else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
