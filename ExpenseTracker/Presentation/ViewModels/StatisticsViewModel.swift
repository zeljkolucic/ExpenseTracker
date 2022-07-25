//
//  StatisticsViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation

class StatisticsViewModel {
    
    func logOut(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        FirebaseAuthenticationService.signOut { error in
            if let error = error {
                failure(error)
            } else {
                success()
            }
        }
    }
    
}
