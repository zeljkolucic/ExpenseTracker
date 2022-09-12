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
    
    func logOut(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        authenticationService.signOut { error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
}
