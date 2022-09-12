//
//  RegistrationViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

enum RegistrationError: Error {
    case firstNameInvalidFormat
    case lastNameInvalidFormat
    case dateOfBirth
    case phoneNumberInvalidFormat
    case emailInvalidFormat
    case passwordTooWeak
    case nonMathingPasswords
}

extension RegistrationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .firstNameInvalidFormat:
            return "firstname_invalid_format"
        case .lastNameInvalidFormat:
            return "lastname_invalid_format"
        case .dateOfBirth:
            return "date_of_birth_error_message"
        case .phoneNumberInvalidFormat:
            return "phone_number_invalid_format"
        case .emailInvalidFormat:
            return "email_invalid_format"
        case .passwordTooWeak:
            return "password_too_weak"
        case .nonMathingPasswords:
            return "non_matching_passwords"
        }
    }
}

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
    
    func verifyFirstStepRegistrationData(completion: @escaping (Result<(), Error>) -> Void) {
        if !firstname.value.matches(pattern: namePattern) {
            completion(.failure(RegistrationError.firstNameInvalidFormat))
        } else if !lastname.value.matches(pattern: namePattern) {
            completion(.failure(RegistrationError.lastNameInvalidFormat))
        } else if dateOfBirth.value.yearsSince(Date.now) < 13 {
            completion(.failure(RegistrationError.dateOfBirth))
        } else if !phoneNumber.value.matches(pattern: phoneNumberPattern) {
            completion(.failure(RegistrationError.phoneNumberInvalidFormat))
        } else {
            completion(.success(()))
        }
    }
    
    func verifySecondStepRegistrationData(completion: @escaping (Result<(), Error>) -> Void) {
        if !email.value.matches(pattern: emailPattern) {
            completion(.failure(RegistrationError.emailInvalidFormat))
        } else if !password.value.matches(pattern: passwordPattern) {
            completion(.failure(RegistrationError.passwordTooWeak))
        } else if password.value != passwordConfirmation.value {
            completion(.failure(RegistrationError.nonMathingPasswords))
        } else {
            authenticationService.register(email: email.value, password: password.value, firstName: firstname.value, lastName: lastname.value, dateOfBirth: dateOfBirth.value, phoneNumber: phoneNumber.value, gender: gender.value.rawValue, completion: completion)
        }
    }
    
}
