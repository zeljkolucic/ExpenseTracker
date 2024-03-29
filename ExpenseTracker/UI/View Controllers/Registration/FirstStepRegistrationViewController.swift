//
//  FirstStepRegistrationViewController.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import UIKit

class FirstStepRegistrationViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var firstnameTextField: RoundedTextField!
    @IBOutlet weak var lastnameTextField: RoundedTextField!
    @IBOutlet weak var dateOfBirthTextField: DateTextField!
    @IBOutlet weak var phoneNumberTextField: RoundedTextField!
    @IBOutlet weak var maleGenderButton: GenderButton!
    @IBOutlet weak var femaleGenderButton: GenderButton!
    @IBOutlet weak var nextButton: RoundedButton!
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    var viewModel: RegistrationViewModel!
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        configureNavigationBar()
        dismissKeyboardWhenTouchOutside()
        configureTextFields()
        bindGenderButtons()
    }
    
    // MARK: - Configuration
    
    private func configureLabels() {
        navigationItem.title = Strings.registration.localized
        firstnameTextField.placeholder = Strings.firstname.localized
        lastnameTextField.placeholder = Strings.lastname.localized
        dateOfBirthTextField.placeholder = Strings.dateOfBirth.localized
        phoneNumberTextField.placeholder = Strings.phoneNumber.localized
        nextButton.setTitle(Strings.next.localized, for: .normal)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(presentQuittingAlert))
    }
    
    private func configureTextFields() {
        firstnameTextField.delegate = self
        firstnameTextField.returnKeyType = .next
        firstnameTextField.autocapitalizationType = .words
        
        lastnameTextField.delegate = self
        lastnameTextField.returnKeyType = .next
        lastnameTextField.autocapitalizationType = .words
        
        dateOfBirthTextField.delegate = self
        configureDateOfBirthTextField()
        
        phoneNumberTextField.delegate = self
        configurePhoneNumberTextField()
    }
    
    private func bindGenderButtons() {
        viewModel.gender.bindAndFire { [weak self] gender in
            guard let self = self else { return }
            
            switch(gender) {
            case .male:
                self.maleGenderButton.select()
                self.femaleGenderButton.deselect()
            case .female:
                self.maleGenderButton.deselect()
                self.femaleGenderButton.select()
            }
        }
    }
    
    private func configureDateOfBirthTextField() {
        dateOfBirthTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelDateOfBirthTextFieldToolbarButton))
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneDateOfBirthTextFieldToolbarButton))
        toolbar.setItems([cancelBarButton, spacing, doneBarButton], animated: true)
        dateOfBirthTextField.inputAccessoryView = toolbar
    }
    
    private func configurePhoneNumberTextField() {
        phoneNumberTextField.keyboardType = .phonePad
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelPhoneNumberTextFieldToolbarButton))
        let spacingBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDonePhoneNumberTextFieldToolbarButton))
        toolbar.items = [cancelBarButton, spacingBarButton, doneBarButton]
        phoneNumberTextField.inputAccessoryView = toolbar
    }
    
    // MARK: - Actions
    
    @IBAction func didTapNextButton() {
//        viewModel.verifyFirstStepRegistrationData { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success:
//                let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
//                guard let viewController = storyboard.instantiateViewController(SecondStepRegistrationViewController.self) else { return }
//                viewController.viewModel = self.viewModel
//                self.navigationController?.pushViewController(viewController, animated: true)
//                
//            case .failure(let error):
//                let title = Strings.errorAlertTitle.localized
//                let message = error.localizedDescription.localized
//                let actions = [UIAlertAction(title: Strings.ok.localized, style: .default)]
//                self.presentAlert(title: title, message: message, actions: actions)
//            }
//        }
        
        let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(SecondStepRegistrationViewController.self) else { return }
        viewController.viewModel = self.viewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func didTapGenderButton(_ sender: UIButton) {
        if sender == maleGenderButton {
            viewModel.gender.value = .male
        } else {
            viewModel.gender.value = .female
        }
    }
    
    @objc private func presentQuittingAlert() {
        let title = Strings.warningAlertTitle.localized
        let message = Strings.quittingAlertMessage.localized
        let actions = [
            UIAlertAction(title: Strings.no.localized, style: .cancel),
            UIAlertAction(title: Strings.yes.localized, style: .destructive, handler: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
        ]
        presentAlert(title: title, message: message, actions: actions)
    }
    
    @objc private func didTapCancelDateOfBirthTextFieldToolbarButton() {
        dateOfBirthTextField.resignFirstResponder()
    }
    
    @objc private func didTapDoneDateOfBirthTextFieldToolbarButton() {
        let date = datePicker.date
        viewModel.dateOfBirth.value = date
        dateOfBirthTextField.text = date.convertToDateFormatString()
        phoneNumberTextField.becomeFirstResponder()
    }
    
    @objc private func didTapCancelPhoneNumberTextFieldToolbarButton() {
        phoneNumberTextField.resignFirstResponder()
    }
    
    @objc private func didTapDonePhoneNumberTextFieldToolbarButton() {
        phoneNumberTextField.resignFirstResponder()
    }
    
}

// MARK: - Text Field Delegate

extension FirstStepRegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }
        
        if textField == firstnameTextField {
            viewModel.firstname.value = text
        } else if textField == lastnameTextField {
            viewModel.lastname.value = text
        } else if textField == phoneNumberTextField {
            viewModel.phoneNumber.value = text
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstnameTextField {
            lastnameTextField.becomeFirstResponder()
        } else if textField == lastnameTextField {
            dateOfBirthTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
            phoneNumberTextField.resignFirstResponder()
        }
        
        return true
    }
    
}
