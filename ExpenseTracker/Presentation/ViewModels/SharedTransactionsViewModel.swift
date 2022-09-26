//
//  SharedTransactionsViewModel.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 27.9.22..
//

import Foundation

class SharedTransactionsViewModel {
    let transactionsRepository: TransactionsRepository
    
    let monthlyTransactionsList: FirestoreMonthlyTransactions
    var transactions = [FirestoreTransaction]()
    
    init(transactionsRepository: TransactionsRepository, monthlyTransactionsList: FirestoreMonthlyTransactions) {
        self.transactionsRepository = transactionsRepository
        self.monthlyTransactionsList = monthlyTransactionsList
    }
    
    func getTransactions(completion: @escaping (Result<(), Error>) -> Void) {
        transactionsRepository.getTransactions(in: monthlyTransactionsList) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let transactions):
                self.transactions = transactions
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
