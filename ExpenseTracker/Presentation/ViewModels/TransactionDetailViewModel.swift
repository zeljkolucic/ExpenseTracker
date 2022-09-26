//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/20/22.
//

import Foundation

class TransactionDetailViewModel {
    private let authenticationService: AuthenticationService
    private let transactionsRepository: TransactionsRepository
    private let categoriesRepository: CategoriesRepository
    
    var transaction: FirestoreTransaction
    var subcategories = [FirestoreSubcategory]()
    
    init(authenticationService: AuthenticationService, transactionsRepository: TransactionsRepository, categoriesRepository: CategoriesRepository, transaction: FirestoreTransaction = FirestoreTransaction(value: 0.0, date: .now, category: "Food", subcategory: "Groceries", methodOfPayment: MethodOfPayment.cash.localized)) {
        self.authenticationService = authenticationService
        self.transactionsRepository = transactionsRepository
        self.categoriesRepository = categoriesRepository
        self.transaction = transaction
    }
    
    func addTransaction(completion: @escaping (Result<(), Error>) -> Void) {
        guard let email = authenticationService.email else {
            completion(.failure(NSError()))
            return
        }
        
        let month = transaction.date.convertToYearMonthFormat()
        transactionsRepository.add(transaction: transaction, ownerEmail: email, month: month, completion: completion)
    }
    
    func getSubcategories(completion: @escaping (Result<(), Error>) -> Void) {
        categoriesRepository.getSubcategories { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let subcategories):
                self.subcategories = subcategories
                
                if !subcategories.isEmpty {
                    self.transaction.subcategory = subcategories[0].name
                    self.transaction.category = subcategories[0].category
                }
                
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
