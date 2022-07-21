//
//  Date+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/21/22.
//

import Foundation

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
}
