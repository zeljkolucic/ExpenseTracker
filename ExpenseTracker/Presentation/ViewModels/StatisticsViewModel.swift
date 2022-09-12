//
//  StatisticsViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation

class StatisticsViewModel {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signOut(completion: completion)
    }
    
}
