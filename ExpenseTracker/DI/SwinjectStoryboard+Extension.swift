//
//  SwinjectStoryboard+Extension.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    
    class func setup() {
        let _ = Assembler([
            UserAssembly()
        ], container: defaultContainer)
    }
    
    static let threadSafeContainer: Resolver = defaultContainer.synchronize()
    
    class func provideAuthenticationService() -> AuthenticationService {
        let userRepository = threadSafeContainer.resolve(UserRepository.self) ?? FirestoreUserRepository()
        return threadSafeContainer.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
    }
    
}
