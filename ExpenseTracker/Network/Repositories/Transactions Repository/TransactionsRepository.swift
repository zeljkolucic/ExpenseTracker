//
//  TransactionsRepository.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Foundation

protocol TransactionsRepository {
    func get(completion: @escaping (Result<[FirestoreTransaction], Error>) -> Void)
    func add(transaction: FirestoreTransaction, completion: @escaping ((Result<(), Error>) -> Void))
}
