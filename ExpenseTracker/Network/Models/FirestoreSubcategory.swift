//
//  FirestoreSubcategory.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 22.9.22..
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreSubcategory: Identifiable, Codable {
    @DocumentID var id: String?
    let name: String
    let category: String
}
