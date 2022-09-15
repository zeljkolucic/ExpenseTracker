//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/20/22.
//

import Foundation

class TransactionDetailViewModel {
    private let authenticationService: AuthenticationService
    private let repository: TransactionsRepository
    
    var transaction: FirestoreTransaction
    
    init(authenticationService: AuthenticationService, repository: TransactionsRepository, transaction: FirestoreTransaction = FirestoreTransaction(value: 0.0, date: .now, category: "Food", subcategory: "Groceries", methodOfPayment: MethodOfPayment.cash.localized)) {
        self.authenticationService = authenticationService
        self.repository = repository
        self.transaction = transaction
    }
    
    func addTransaction(completion: @escaping (Result<(), Error>) -> Void) {
        guard let email = authenticationService.email else {
            completion(.failure(NSError()))
            return
        }
        
        let month = transaction.date.convertToYearMonthFormat()
        repository.add(transaction: transaction, ownerEmail: email, month: month, completion: completion)
    }
}
