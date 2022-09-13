//
//  AuthenticationService.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/25/22.
//

import Firebase

class FirebaseAuthenticationService: AuthenticationService {
    
    
    private var authenticationStateHandle: AuthStateDidChangeListenerHandle?
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
        addListeners()
    }
    
    var user: User?
    var email: String? {
        return Auth.auth().currentUser?.email
    }
    
    func isSignedIn() -> Bool {
        user = Auth.auth().currentUser
        return user != nil
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func signOut(completion: @escaping (Result<(), Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String, dateOfBirth: Date, phoneNumber: String, gender: String, completion: @escaping ((Result<(), Error>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let authResult = authResult, let additionalUserInfo = authResult.additionalUserInfo, additionalUserInfo.isNewUser {
                let user = FirestoreUser(id: authResult.user.uid, email: email, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth, phoneNumber: phoneNumber, gender: gender)
                self.userRepository.add(user: user) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        authResult.user.sendEmailVerification()
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    private func addListeners() {
        if let handle = authenticationStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
        authenticationStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
}
