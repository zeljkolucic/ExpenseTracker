//
//  MethodOfPayment.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/21/22.
//

import Foundation

enum MethodOfPayment: CaseIterable {
    case cash, card
    
    var localized: String {
        switch self {
        case .cash:
            return Strings.cash.localized
        case .card:
            return Strings.card.localized
        }
    }
}
