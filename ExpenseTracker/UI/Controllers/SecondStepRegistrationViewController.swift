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
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        configureLayout()
    }
    
    // MARK: - Layout
    
    private func configureLayout() {
        
    }
    
}
