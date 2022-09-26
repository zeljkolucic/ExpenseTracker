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
                self.transactions = transactions.sortedDescending()
                completion(.success(()))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func share(monthlyTransactionsIndex index: Int, withUser email: String, completion: @escaping (Result<(), Error>) -> Void) {
        let ownerEmail = monthlyTransactions[index].ownerEmail
        let month = monthlyTransactions[index].month
        
        repository.shareMonthlyTransactions(withUser: email, ownerEmail: ownerEmail, month: month, completion: completion)
    }
    
    func delete(index: Int, completion: @escaping (Result<(), Error>) -> Void) {
        guard let ownerEmail = authenticationService.email else {
            completion(.failure(NSError()))
            return
        }
        
        let transaction = transactions[index]
        let month = transaction.date.convertToYearMonthFormat()
        repository.delete(transaction: transaction, ownerEmail: ownerEmail, month: month, completion: completion)
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        authenticationService.signOut(completion: completion)
    }
    
    func saveCsv(for monthlyTransactionListIndex: Int, completion: @escaping (Result<String, Error>) -> Void) {
        let headers = [Strings.value, Strings.date, Strings.category, Strings.subcategory, Strings.methodOfPayment]
        var fileContent: String = headers.joined(separator: ",").appending(";")
        
        for transaction in transactions {
            let row = String(transaction.value).appending(",")
                .appending(transaction.date.convertToSimpleDateFormatString()).appending(",")
                .appending(transaction.category).appending(",")
                .appending(transaction.subcategory).appending(",")
                .appending(transaction.methodOfPayment).appending(";")
            
            fileContent.append("\n")
            fileContent.append(row)
        }
        
        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: true)
            
            let monthlyTransactionsList = monthlyTransactions[monthlyTransactionListIndex]
            let fileName = monthlyTransactionsList.ownerEmail.appending("_").appending(monthlyTransactionsList.month)
            let fileURL = path.appendingPathComponent("\(fileName).csv")
            try fileContent.write(to: fileURL, atomically: true, encoding: .utf8)
            
            completion(.success(fileName))
            
        } catch {
            completion(.failure(error))
        }
    }
}
