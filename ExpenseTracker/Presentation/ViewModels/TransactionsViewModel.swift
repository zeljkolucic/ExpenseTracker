//
//  TransactionsViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/22/22.
//

import Foundation

class TransactionsViewModel {
    
    private let repository: TransactionsRepository
    private let authenticationService: AuthenticationService
    
    init(repository: TransactionsRepository, authenticationService: AuthenticationService) {
        self.repository = repository
        self.authenticationService = authenticationService
    }
    
    func getTransactions() {
        repository.get { result in
            switch result {
            case .success(let transactions):
                print(transactions)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
