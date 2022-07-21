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
    
    private let viewModel = RegistrationViewModel()
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLabels()
        configureNavigationBar()
        dismissKeyboardWhenTouchOutside()
        defineActions()
        configureTextFields()
        bind()
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(presentAlert))
    }
    
    private func defineActions() {
        maleGenderButton.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)
        femaleGenderButton.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
    }
    
    private func configureTextFields() {
        firstnameTextField.delegate = self
        firstnameTextField.returnKeyType = .next
        
        lastnameTextField.delegate = self
        lastnameTextField.returnKeyType = .next
        
        dateOfBirthTextField.delegate = self
        configureDateOfBirthTextFieldInput()
        
        phoneNumberTextField.delegate = self
        configurePhoneNumberTextFieldInput()
    }
    
    private func bind() {
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
    
    private func configureDateOfBirthTextFieldInput() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        dateOfBirthTextField.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCancelToolbarButton))
        let spacing = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneToolbarButton))
        toolbar.setItems([cancelBarButton, spacing, doneBarButton], animated: true)
        dateOfBirthTextField.inputAccessoryView = toolbar
    }
    
    private func configurePhoneNumberTextFieldInput() {
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
    
    @objc private func didTapNextButton() {
        let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(SecondStepRegistrationViewController.self) else { return }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc private func didTapGenderButton(_ sender: UIButton) {
        if sender == maleGenderButton {
            viewModel.gender.value = .male
        } else {
            viewModel.gender.value = .female
        }
    }
    
    @objc private func presentAlert() {
        let alertController = UIAlertController(title: Strings.warningAlertTitle.localized, message: Strings.quittingAlertMessage.localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Strings.no.localized, style: .cancel))
        alertController.addAction(UIAlertAction(title: Strings.yes.localized, style: .destructive, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        present(alertController, animated: true)
    }
    
    @objc private func didTapCancelToolbarButton() {
        dateOfBirthTextField.resignFirstResponder()
    }
    
    @objc private func didTapDoneToolbarButton() {
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
            view.endEditing(true)
        }
        
        return true
    }
    
}
