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
    
    var transactions: [FirestoreTransaction] = []
    
    init(repository: TransactionsRepository, authenticationService: AuthenticationService) {
        self.repository = repository
        self.authenticationService = authenticationService
    }
    
    func getTransactions(completion: @escaping (Result<(), Error>) -> Void) {
        repository.get { result in
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
