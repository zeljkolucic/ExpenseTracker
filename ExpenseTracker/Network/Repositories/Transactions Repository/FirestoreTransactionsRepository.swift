//
//  TransactionsRepository.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/22/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreTransactionsRepository: TransactionsRepository {
    
    private let store = Firestore.firestore()
    private let collectionPath = "monthlyTransactions"
    private let subcollectionPath = "transactions"
    
    func getMonthlyTransactions(email: String, completion: @escaping (Result<[FirestoreMonthlyTransactions], Error>) -> Void) {
        store.collection(collectionPath).addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = NSError(domain: "Query snapshot is nil.", code: 400)
                completion(.failure(error))
                return
            }
            
            let transactions = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreMonthlyTransactions.self)
            }

            completion(.success(transactions))
        }
    }
    
    func getTransactions(in monthlyTransactions: FirestoreMonthlyTransactions, completion: @escaping (Result<[FirestoreTransaction], Error>) -> Void) {
        guard let monthlyTransactionId = monthlyTransactions.id else {
            completion(.failure(NSError()))
            return
        }
        
        store.collection(collectionPath).document(monthlyTransactionId).collection(subcollectionPath).addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = NSError(domain: "Query snapshot is nil.", code: 400)
                completion(.failure(error))
                return
            }
            
            let transactions = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreTransaction.self)
            }

            completion(.success(transactions))
        }
    }
    
    func add(transaction: FirestoreTransaction, completion: @escaping ((Result<(), Error>) -> Void)) {
        do {
            _ = try store.collection(collectionPath).addDocument(from: transaction, completion: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            })
        } catch {
            completion(.failure(error))
        }
    }
    
    func shareMonthlyTransactions(withUser email: String, completion: @escaping (Result<(), Error>) -> Void) {
        
    }
    
    func getSharedMonthlyTransactions(withUser email: String, completion: @escaping (Result<[FirestoreMonthlyTransactions], Error>) -> Void) {
        store.collection(collectionPath).whereField("viewers", arrayContains: email).addSnapshotListener { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                let error = NSError(domain: "Query snapshot is nil.", code: 400)
                completion(.failure(error))
                return
            }
            
            let transactions = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreMonthlyTransactions.self)
            }

            completion(.success(transactions))
        }
    }
    
}
