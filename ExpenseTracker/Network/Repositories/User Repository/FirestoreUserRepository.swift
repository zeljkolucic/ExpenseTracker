//
//  FirestoreUserRepository.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreUserRepository: UserRepository {
    
    private let store = Firestore.firestore()
    private let collectionPath = "users"
    
    func add(user: FirestoreUser, completion: @escaping ((Error?) -> Void)) {
        do {
            _ = try store.collection(collectionPath).addDocument(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func addUser(_ id: String?, _ email: String, _ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ phoneNumber: String, _ gender: String, completion: @escaping ((Error?) -> Void)) {
        do {
            let user = FirestoreUser(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, gender: gender)
            _ = try store.collection(collectionPath).addDocument(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
}
