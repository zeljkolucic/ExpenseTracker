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
    @IBOutlet weak var dateOfBirthInputField: DateInputField!
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
        bind()
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
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(presentAlert))
    }
    
    private func defineActions() {
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        maleGenderButton.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)
        femaleGenderButton.addTarget(self, action: #selector(didTapGenderButton(_:)), for: .touchUpInside)
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
    
    // MARK: - Actions
    
    @objc private func didTapNextButton() {
        let storyboard = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "SecondStepRegistrationViewController") as? SecondStepRegistrationViewController else { return }
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
    
}
