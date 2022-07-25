//
//  FirestoreUserRepository.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreUserRepository {
    
    static let shared: FirestoreUserRepository = {
        let instance = FirestoreUserRepository()
        return instance
    }()
    
    private init() { }
    
    private let store = Firestore.firestore()
    private let collectionPath = "users"
    
    struct User: Identifiable, Encodable {
        @DocumentID var id: String?
        var email: String
        var firstName: String
        var lastName: String
        var dateOfBirth: Date
        var phoneNumber: String
        var gender: String
    }
    
    func add(user: User, completion: @escaping ((Error?) -> Void)) {
        do {
            _ = try store.collection(collectionPath).addDocument(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func addUser(_ id: String?, _ email: String, _ firstName: String, _ lastName: String, _ dateOfBirth: Date, _ phoneNumber: String, _ gender: String, completion: @escaping ((Error?) -> Void)) {
        do {
            let user = User(id: id, email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, gender: gender)
            _ = try store.collection(collectionPath).addDocument(from: user)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
}
