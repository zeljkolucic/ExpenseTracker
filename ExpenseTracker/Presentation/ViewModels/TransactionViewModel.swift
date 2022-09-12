//
//  TransactionViewModel.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/20/22.
//

import Foundation

class TransactionViewModel {
    
    var value: Float
    var category: String
    var subcategory: String
    var date: Date
    var methodOfPayment: MethodOfPayment
    
    private let repository: TransactionsRepository
    
    init(repository: TransactionsRepository, value: Float = 0.0, category: String = "", subcategory: String = "", date: Date = Date.now, methodOfPayment: MethodOfPayment = .cash) {
        self.repository = repository
        self.value = value
        self.category = category
        self.subcategory = subcategory
        self.date = date
        self.methodOfPayment = methodOfPayment
    }
    
}
