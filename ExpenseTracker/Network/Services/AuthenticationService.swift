//
//  AuthenticationService.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Foundation

protocol AuthenticationService {
    func signIn(email: String, password: String, completion: @escaping ((Error?) -> Void))
    func signOut(completion: ((Error?) -> Void))
    func register(email: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, phoneNumber: String, gender: String, completion: @escaping ((Error?) -> Void))
}
