//
//  TransactionsRepository.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Foundation

protocol TransactionsRepository {
    func getMonthlyTransactions(email: String, completion: @escaping (Result<[FirestoreMonthlyTransactions], Error>) -> Void)
    func getTransactions(in monthlyTransactions: FirestoreMonthlyTransactions, completion: @escaping (Result<[FirestoreTransaction], Error>) -> Void)
    func add(transaction: FirestoreTransaction, ownerEmail: String, month: String, completion: @escaping (Result<(), Error>) -> Void)
    func getSharedMonthlyTransactions(withUser email: String, completion: @escaping (Result<[FirestoreMonthlyTransactions], Error>) -> Void)
    func shareMonthlyTransactions(withUser email: String, ownerEmail: String, month: String, completion: @escaping (Result<(), Error>) -> Void)
}
