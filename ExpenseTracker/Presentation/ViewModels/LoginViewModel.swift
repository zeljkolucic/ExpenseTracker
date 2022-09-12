//
//  LoginViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

class LoginViewModel {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    var email = Binding<String>("")
    var password = Binding<String>("")
    
    func signIn(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        authenticationService.signIn(email: email.value, password: password.value) { error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
}
