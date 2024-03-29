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
    
    func add(transaction: FirestoreTransaction, ownerEmail: String, month: String, completion: @escaping (Result<(), Error>) -> Void) {
        store.collection(collectionPath).whereField("ownerEmail", isEqualTo: ownerEmail).whereField("month", isEqualTo: month).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                return
            }
            
            let monthlyTransactionsLists = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreMonthlyTransactions.self)
            }
            
            let store = self.store
            let collectionPath = self.collectionPath
            let subcollectionPath = self.subcollectionPath
            
            do {
                // If there are no `monthlyTransactionsLists` for the given user and month, one needs to be created first
                if monthlyTransactionsLists.isEmpty {
                    let monthlyTransactionsList = FirestoreMonthlyTransactions(
                        month: month,
                        ownerEmail: ownerEmail,
                        total: transaction.value,
                        viewers: []
                    )
                    
                    let documentReference = try store.collection(collectionPath).addDocument(from: monthlyTransactionsList)
                    _ = try documentReference.collection(subcollectionPath).addDocument(from: transaction)
                    
                } else if let monthlyTransactionsList = monthlyTransactionsLists.first, let documentId = monthlyTransactionsList.id {
                    _ = try store.collection(collectionPath).document(documentId).collection(subcollectionPath).addDocument(from: transaction)
                    
                    let totalValue = monthlyTransactionsList.total + transaction.value
                    self.updateTotalValue(for: documentId, newValue: totalValue)
                }
                
                completion(.success(()))
                
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func delete(transaction: FirestoreTransaction, ownerEmail: String, month: String, completion: @escaping (Result<(), Error>) -> Void) {
        store.collection(collectionPath).whereField("ownerEmail", isEqualTo: ownerEmail).whereField("month", isEqualTo: month).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let querySnapshot = querySnapshot else {
                return
            }
            
            let monthlyTransactionsLists = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreMonthlyTransactions.self)
            }
            
            let store = self.store
            let collectionPath = self.collectionPath
            let subcollectionPath = self.subcollectionPath
            
            if !monthlyTransactionsLists.isEmpty, let monthlyTransactionsList = monthlyTransactionsLists.first, let monthlyTransactionsListId = monthlyTransactionsList.id, let transactionId = transaction.id {
                store.collection(collectionPath).document(monthlyTransactionsListId).collection(subcollectionPath).document(transactionId).delete()
                
                // If deleting the last document, then the whole collection needs to be deleted
                if monthlyTransactionsLists.count == 1 {
                    store.collection(collectionPath).document(monthlyTransactionsListId).delete()
                } else {
                    let totalValue = monthlyTransactionsList.total - transaction.value
                    self.updateTotalValue(for: monthlyTransactionsListId, newValue: totalValue)
                    completion(.success(()))
                }
            }
        }
    }
    
    private func updateTotalValue(for monthlyTransactionsDocumentId: String, newValue: Float) {
        store.collection(collectionPath).document(monthlyTransactionsDocumentId).updateData([
            "total": newValue
        ])
    }
    
    func shareMonthlyTransactions(withUser email: String, ownerEmail: String, month: String, completion: @escaping (Result<(), Error>) -> Void) {
        store.collection(collectionPath).whereField("ownerEmail", isEqualTo: ownerEmail).whereField("month", isEqualTo: month).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let querySnapshot = querySnapshot else {
                return
            }
            
            for document in querySnapshot.documents {
                if var viewers = document.get("viewers") as? [String] {
                    viewers.append(email)
                    document.reference.updateData([
                        "viewers": viewers
                    ])
                }
            }
        }
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
