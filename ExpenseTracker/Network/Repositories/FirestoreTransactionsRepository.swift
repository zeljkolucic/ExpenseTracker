//
//  TransactionsRepository.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/22/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreTransactionsRepository {
    
    static let shared: FirestoreTransactionsRepository = {
        let instance = FirestoreTransactionsRepository()
        return instance
    }()
    
    private init() {}
    
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
            
            let transactions = querySnapshot.documents.compactMap({ document in
                try? document.data(as: FirestoreTransaction.self)
            })

            completion(.success(transactions))
        }
        
    }
    
}
