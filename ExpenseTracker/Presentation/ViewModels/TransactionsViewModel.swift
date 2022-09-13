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
    
    var monthlyTransactions: [FirestoreMonthlyTransactions] = []
    var transactions: [FirestoreTransaction] = []
    
    init(repository: TransactionsRepository, authenticationService: AuthenticationService) {
        self.repository = repository
        self.authenticationService = authenticationService
    }
    
    func getMonthlyTransactions(completion: @escaping (Result<(), Error>) -> Void) {
        guard let email = authenticationService.email else {
            completion(.failure(NSError()))
            return
        }
        
        repository.getMonthlyTransactions(email: email) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let monthlyTransactions):
                self.monthlyTransactions = monthlyTransactions.sorted()
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTransactions(in monthlyTransactions: FirestoreMonthlyTransactions, completion: @escaping (Result<(), Error>) -> Void) {
        repository.getTransactions(in: monthlyTransactions) { result in
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signOut(completion: completion)
    }
    
}
