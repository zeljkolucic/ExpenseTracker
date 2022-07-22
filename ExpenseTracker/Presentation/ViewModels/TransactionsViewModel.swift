//
//  TransactionsViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/22/22.
//

import Foundation

class TransactionsViewModel {
    
    private let repository = FirestoreTransactionsRepository.shared
    
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
    
}
