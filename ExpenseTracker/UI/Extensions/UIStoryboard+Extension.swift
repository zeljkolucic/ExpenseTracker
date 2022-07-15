//
//  UIStoryboard+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/15/22.
//

import UIKit

extension UIStoryboard {
    
    func instantiateViewController<T>(_ type: T.Type) -> T? {
        let className = String(describing: type)
        return instantiateViewController(withIdentifier: className) as? T
    }
    
}
