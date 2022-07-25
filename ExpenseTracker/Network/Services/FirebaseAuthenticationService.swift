//
//  AuthenticationService.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Firebase

class FirebaseAuthenticationService {
    
    var user: User?
    private var authenticationStateHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        addListeners()
    }
    
    static func signIn(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    static func signOut(completion: ((Error?) -> Void)) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    static func register(email: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, phoneNumber: String, gender: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let authResult = authResult, let additionalUserInfo = authResult.additionalUserInfo, additionalUserInfo.isNewUser {
                let user = FirestoreUserRepository.User(id: authResult.user.uid, email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, gender: gender)
                FirestoreUserRepository.shared.add(user: user) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        authResult.user.sendEmailVerification()
                        completion(nil)
                    }
                }
            }
        }
    }
    
    private func addListeners() {
        if let handle = authenticationStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandle = Auth.auth()
            .addStateDidChangeListener({ [weak self] _, user in
                self?.user = user
            })
    }
}
