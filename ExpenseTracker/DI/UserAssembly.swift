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
        
        container.register(TransactionViewModel.self) { resolver in
            let repository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            return TransactionViewModel(repository: repository)
        }
        
        container.register(TransactionsViewModel.self) { resolver in
            let transactionsRepository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            return TransactionsViewModel(repository: transactionsRepository, authenticationService: authenticationService)
        }
        
        container.register(StatisticsViewModel.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            return StatisticsViewModel(authenticationService: authenticationService)
        }
        
        container.register(SharedWithYouViewModel.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            return SharedWithYouViewModel(authenticationService: authenticationService)
        }
        
        // MARK: - View Controllers
        
        container.storyboardInitCompleted(LoginViewController.self) { resolver, viewController in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: repository)
            let viewModel = resolver.resolve(LoginViewModel.self) ?? LoginViewModel(authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(FirstStepRegistrationViewController.self) { resolver, viewController in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: repository)
            let viewModel = resolver.resolve(RegistrationViewModel.self) ?? RegistrationViewModel(authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(SecondStepRegistrationViewController.self) { resolver, viewController in
            let repository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: repository)
            let viewModel = resolver.resolve(RegistrationViewModel.self) ?? RegistrationViewModel(authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(TransactionsViewController.self) { resolver, viewController in
            let transactionsRepository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            let viewModel = resolver.resolve(TransactionsViewModel.self) ?? TransactionsViewModel(repository: transactionsRepository, authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(SharedWithYouViewController.self) { resolver, viewController in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            let viewModel = resolver.resolve(SharedWithYouViewModel.self) ?? SharedWithYouViewModel(authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
        #warning("DetailTransactionViewController is not initialized from storyboard, but from a nib, therefore its dependencies cannot be resolved as in the following code. It would require a factory to populate its dependencies after instantiating the mentioned view controller. It is the best to implement this viewController in storyboards as well.")
        container.storyboardInitCompleted(DetailTransactionViewController.self) { resolver, viewController in
            let repository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            let viewModel = resolver.resolve(TransactionViewModel.self) ?? TransactionViewModel(repository: repository)
            viewController.viewModel = viewModel
        }
        
        container.storyboardInitCompleted(StatisticsViewController.self) { resolver, viewController in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            let viewModel = resolver.resolve(StatisticsViewModel.self) ?? StatisticsViewModel(authenticationService: authenticationService)
            viewController.viewModel = viewModel
        }
        
    }
    
}
