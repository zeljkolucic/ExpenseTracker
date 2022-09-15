//
//  StatisticsViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation

class StatisticsViewModel {
    
    private let authenticationService: AuthenticationService
    private let repository: TransactionsRepository
    
    var monthlyTransactions = [FirestoreMonthlyTransactions]()
    
    init(authenticationService: AuthenticationService, repository: TransactionsRepository) {
        self.authenticationService = authenticationService
        self.repository = repository
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signOut(completion: completion)
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
    
}
