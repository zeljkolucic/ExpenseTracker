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
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        navigationItem.title = Strings.registration.localized
        firstnameTextField.placeholder = Strings.firstname.localized
        lastnameTextField.placeholder = Strings.lastname.localized
        dateOfBirthInputField.placeholder = Strings.dateOfBirth.localized
        phoneNumberTextField.placeholder = Strings.phoneNumber.localized
        nextButton.setTitle(Strings.next.localized, for: .normal)
    }
    
}
