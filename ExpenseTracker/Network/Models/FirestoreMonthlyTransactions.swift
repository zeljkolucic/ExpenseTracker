//
//  FirestoreMonthlyTransactions.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 13.9.22..
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreMonthlyTransactions: Identifiable, Codable {
    @DocumentID var id: String?
    var month: String
    var ownerEmail: String
    var total: Float
    var viewers: [String]
    
    var prettyDateFormatMonth: String {
        return month.convertToPrettyDateFormat()
    }
}

