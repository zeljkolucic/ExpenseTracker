//
//  Array+Extension.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 14.9.22..
//

import Foundation

extension Array where Element == FirestoreMonthlyTransactions {
    func sorted() -> Array {
        return self.sorted { $0.month < $1.month }
    }
}
