//
//  Date+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/21/22.
//

import Foundation

extension Date {
    func convertToYearMonthFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMM"
        return dateFormatter.string(from: self)
    }
    
    func convertToDateFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: self)
    }
    
    func convertToDateAndTimeFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func convertToSimpleDateFormatString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/MM/yyyy hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func yearsSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self, to: date)
        return components.year ?? 0
    }
}
