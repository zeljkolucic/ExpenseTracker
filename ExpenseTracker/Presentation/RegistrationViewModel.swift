//
//  RegistrationViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

class RegistrationViewModel {
    
    enum Gender {
        case male, female
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
    
    func verifyFirstStepRegistrationData(success: @escaping (() -> Void), failure: @escaping ((String) -> Void)) {
        if !firstname.value.matches(pattern: namePattern) {
            failure(Strings.firstnameInvalidFormat.localized)
        } else if !lastname.value.matches(pattern: namePattern) {
            failure(Strings.lastnameInvalidFormat.localized)
        } else if dateOfBirth.value.yearsSince(Date.now) < 13 {
            failure(Strings.dateOfBirthErrorMessage.localized)
        } else if !phoneNumber.value.matches(pattern: phoneNumberPattern) {
            failure(Strings.phoneNumberInvalidFormat.localized)
        }
        
        success()
    }
    
}
