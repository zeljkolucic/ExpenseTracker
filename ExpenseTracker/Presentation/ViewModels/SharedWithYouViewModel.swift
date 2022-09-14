//
//  SharedWithYouViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation

class SharedWithYouViewModel {
    private let authenticationService: AuthenticationService
    private let repository: TransactionsRepository
    
    var monhtlyTransactions = [FirestoreMonthlyTransactions]()
    
    init(authenticationService: AuthenticationService, repository: TransactionsRepository) {
        self.authenticationService = authenticationService
        self.repository = repository
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signOut(completion: completion)
    }
    
    func getSharedMonthlyTransactions(completion: @escaping (Result<(), Error>) -> Void) {
        guard let email = authenticationService.email else {
            completion(.failure(NSError()))
            return
        }
        
        repository.getSharedMonthlyTransactions(withUser: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let monthlyTransactions):
                self.monhtlyTransactions = monthlyTransactions
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
