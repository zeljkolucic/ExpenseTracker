//
//  UserRepository.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Foundation

protocol UserRepository {
    func add(user: FirestoreUser, completion: @escaping ((Error?) -> Void))
}
