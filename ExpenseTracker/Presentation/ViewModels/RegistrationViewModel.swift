//
//  RegistrationViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

class RegistrationViewModel {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    enum Gender: String {
        case male = "male"
        case female = "female"
    }
    
    var firstname = Binding<String>("")
    var lastname = Binding<String>("")
    var dateOfBirth = Binding<Date>(Date.now)
    var phoneNumber = Binding<String>("")
    var gender = Binding<Gender>(.male)
    var email = Binding<String>("")
    var password = Binding<String>("")
    var passwordConfirmation = Binding<String>("")
    
    private let namePattern = "^[A-Z][a-z]+$"
    private let phoneNumberPattern = "^\\d{8,10}$"
    private let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    private let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
    
    func verifyFirstStepRegistrationData(success: @escaping (() -> Void), failure: @escaping ((String) -> Void)) {
        if !firstname.value.matches(pattern: namePattern) {
            failure(Strings.firstnameInvalidFormat.localized)
        } else if !lastname.value.matches(pattern: namePattern) {
            failure(Strings.lastnameInvalidFormat.localized)
        } else if dateOfBirth.value.yearsSince(Date.now) < 13 {
            failure(Strings.dateOfBirthErrorMessage.localized)
        } else if !phoneNumber.value.matches(pattern: phoneNumberPattern) {
            failure(Strings.phoneNumberInvalidFormat.localized)
        } else {
            success()
        }
    }
    
    func verifySecondStepRegistrationData(success: @escaping (() -> Void), failure: @escaping ((String) -> Void)) {
        if !email.value.matches(pattern: emailPattern) {
            failure(Strings.emailInvalidFormat.localized)
        } else if !password.value.matches(pattern: passwordPattern) {
            failure(Strings.passwordTooWeak.localized)
        } else if password.value != passwordConfirmation.value {
            failure(Strings.nonMathingPasswords.localized)
        } else {
            authenticationService.register(email: email.value, password: password.value, firstName: firstname.value, lastName: lastname.value, dateOfBirth: dateOfBirth.value, phoneNumber: phoneNumber.value, gender: gender.value.rawValue) { error in
                if let error = error {
                    failure(error.localizedDescription)
                }
                
                success()
            }
        }
    }
    
}
