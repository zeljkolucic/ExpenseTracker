//
//  AuthenticationService.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Firebase

class FirebaseAuthenticationService: AuthenticationService {
    
    var user: User?
    private var authenticationStateHandle: AuthStateDidChangeListenerHandle?
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        addListeners()
    }
    
    func signIn(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func signOut(completion: ((Error?) -> Void)) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, phoneNumber: String, gender: String, completion: @escaping ((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(error)
                return
            }
            
            if let authResult = authResult, let additionalUserInfo = authResult.additionalUserInfo, additionalUserInfo.isNewUser {
                
                let user = FirestoreUser(id: authResult.user.uid, email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, gender: gender)
                self.userRepository.add(user: user) { error in
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
