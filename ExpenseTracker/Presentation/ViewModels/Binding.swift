//
//  Binding.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/12/22.
//

import Foundation

class Binding<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ val: T) {
        value = val
    }
}
