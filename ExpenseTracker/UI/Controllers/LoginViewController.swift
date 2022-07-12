//
//  LoginViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/11/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: RoundedTextField!
    @IBOutlet weak var passwordTextField: RoundedTextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        configureLayout()
    }
    
    // MARK: - Layout
    
    private func configureLayout() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
