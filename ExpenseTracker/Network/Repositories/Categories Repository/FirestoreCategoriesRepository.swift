//
//  FirestoreCategoriesRepository.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 22.9.22..
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreCategoriesRepository: CategoriesRepository {
    private let store = Firestore.firestore()
    private let collectionPath = "subcategories"
    
    func getSubcategories(completion: @escaping (Result<[FirestoreSubcategory], Error>) -> Void) {
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
            
            let subcategories = querySnapshot.documents.compactMap { document in
                try? document.data(as: FirestoreSubcategory.self)
            }

            completion(.success(subcategories))
        }
    }
}
