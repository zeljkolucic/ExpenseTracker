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
    
    func signIn(email: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signIn(email: email, password: password, completion: completion)
    }
    
}
