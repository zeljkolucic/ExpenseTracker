//
//  FirstStepRegistrationViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class FirstStepRegistrationViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var firstnameTextField: RoundedTextField!
    @IBOutlet weak var lastnameTextField: RoundedTextField!
    @IBOutlet weak var dateOfBirthInputField: DateInputField!
    @IBOutlet weak var phoneNumberTextField: RoundedTextField!
    @IBOutlet weak var maleGenderButton: GenderButton!
    @IBOutlet weak var femaleGenderButton: GenderButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
    }
    
    // MARK: - Layout
    
    private func configureLayout() {
        
    }
    
}
