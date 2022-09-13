//
//  FirestoreTransaction.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/22/22.
//

import Foundation
import FirebaseFirestoreSwift

struct FirestoreTransaction: Identifiable, Codable {
    @DocumentID var id: String?
    var value: Float
    var date: Date
    var category: String
    var subcategory: String
    var methodOfPayment: String
}
