//
//  SharedAssembly.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 14.9.22..
//

import Swinject
import SwinjectStoryboard

class SharedAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SharedWithYouViewModel.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            let repository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            return SharedWithYouViewModel(authenticationService: authenticationService, repository: repository)
        }
        
        container.storyboardInitCompleted(SharedWithYouViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(SharedWithYouViewModel.self)
            viewController.viewModel = viewModel
        }
    }
}
