//
//  UITableView+Extension.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/14/22.
//

import UIKit

extension UITableView {
    
    func register(_ type: UITableViewCell.Type) {
        let className = String(describing: type)
        register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }
    
    func dequeueReusableCell<T>(_ type: T.Type, at indexPath: IndexPath) -> T? {
        let className = String(describing: type)
        return dequeueReusableCell(withIdentifier: className, for: indexPath) as? T
    }
    
}
