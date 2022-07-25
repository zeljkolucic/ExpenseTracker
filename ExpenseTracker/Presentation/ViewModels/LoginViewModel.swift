//
//  LoginViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

class LoginViewModel {
    
    var email = Binding<String>("")
    var password = Binding<String>("")
    
    func signIn(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        FirebaseAuthenticationService.signIn(email: email.value, password: password.value) { error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
}
