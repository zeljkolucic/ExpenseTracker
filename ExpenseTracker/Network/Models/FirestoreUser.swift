//
//  FirestoreUser.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreUser: Identifiable, Encodable {
    @DocumentID var id: String?
    var email: String
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var phoneNumber: String
    var gender: String
}
