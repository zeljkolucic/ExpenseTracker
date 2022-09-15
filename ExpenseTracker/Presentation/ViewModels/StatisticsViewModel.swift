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
    var categories = [Category]()
    
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
    
    func getTransactions(in monthlyTransactions: FirestoreMonthlyTransactions, completion: @escaping (Result<(), Error>) -> Void) {
        repository.getTransactions(in: monthlyTransactions) { result in
            switch result {
            case .success(let transactions):
                self.createCategories(from: transactions)
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func createCategories(from transactions: [FirestoreTransaction]) {
        categories = []
        for transaction in transactions {
            if var category = categories.first(where: { $0.title == transaction.category }) {
                category.value += transaction.value
            } else {
                let category = Category(title: transaction.category, value: transaction.value)
                categories.append(category)
            }
        }
        
        // Sort categories descending by value
        categories = categories.sorted { $0.value > $1.value }
    }
    
}
