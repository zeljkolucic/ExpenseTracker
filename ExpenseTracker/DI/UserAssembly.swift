//
//  UserAssembly.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 11.8.22..
//

import Swinject
import SwinjectStoryboard

class UserAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // MARK: - Repositories
        
        container.register(UserRepository.self) { _ in
            FirestoreUserRepository()
        }
        
        container.register(TransactionsRepository.self) { _ in
            FirestoreTransactionsRepository()
        }
        
        container.register(CategoriesRepository.self) { _ in
            FirestoreCategoriesRepository()
        }
        
        // MARK: - Services
        
        container.register(AuthenticationService.self) { resolver in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            return FirebaseAuthenticationService(userRepository: repository)
        }
        
        // MARK: - View Models
        
        container.register(RegistrationViewModel.self) { resolver in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: repository)
            return RegistrationViewModel(authenticationService: authenticationService)
        }
        
        container.register(LoginViewModel.self) { resolver in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: repository)
            return LoginViewModel(authenticationService: authenticationService)
        }
        
        container.register(TransactionDetailViewModel.self) { resolver in
            let authenticationService = SwinjectStoryboard.provideAuthenticationService()
            let transactionsRepository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            let categoriesRepository = resolver.resolve(CategoriesRepository.self) ?? FirestoreCategoriesRepository()
            return TransactionDetailViewModel(authenticationService: authenticationService, transactionsRepository: transactionsRepository, categoriesRepository: categoriesRepository)
        }
        
        container.register(TransactionsViewModel.self) { resolver in
            let transactionsRepository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            return TransactionsViewModel(repository: transactionsRepository, authenticationService: authenticationService)
        }
        
        // MARK: - View Controllers
        
        container.storyboardInitCompleted(LoginViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(LoginViewModel.self)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(FirstStepRegistrationViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(RegistrationViewModel.self)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(SecondStepRegistrationViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(RegistrationViewModel.self)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(TransactionsViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(TransactionsViewModel.self)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(DetailTransactionViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(TransactionDetailViewModel.self)
            viewController.viewModel = viewModel
        }
    }
    
}
