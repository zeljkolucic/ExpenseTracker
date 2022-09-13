//
//  String+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func matches(pattern: String) -> Bool {
        return self.range(of: pattern, options: .regularExpression) != nil
    }
    
    func convertToPrettyDateFormat() -> String {
        guard let intValue = Int(self) else { return self }
        
        let monthValue = intValue % 100
        let yearValue = intValue / 100
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        let month = months[monthValue - 1]
        let year = String(yearValue)
        
        return "\(month) \(year)"
    }
    
}
