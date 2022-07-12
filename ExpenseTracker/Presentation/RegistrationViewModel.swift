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
    
}
