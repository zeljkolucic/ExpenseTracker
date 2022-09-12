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
    private let collectionPath = "transactions"
    
    func get(completion: @escaping (Result<[FirestoreTransaction], Error>) -> Void) {
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
    
}
