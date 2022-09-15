//
//  StatisticsAssembly.swift
//  ExpenseTracker
//
//  Created by Zeljko Lucic on 14.9.22..
//

import Swinject
import SwinjectStoryboard

class StatisticsAssembly: Assembly {
    func assemble(container: Container) {
        // MARK: - View Model
        
        container.register(StatisticsViewModel.self) { resolver in
            let userRepository = resolver.resolve(UserRepository.self) ?? FirestoreUserRepository()
            let authenticationService = resolver.resolve(AuthenticationService.self) ?? FirebaseAuthenticationService(userRepository: userRepository)
            let repository = resolver.resolve(TransactionsRepository.self) ?? FirestoreTransactionsRepository()
            return StatisticsViewModel(authenticationService: authenticationService, repository: repository)
        }
        
        // MARK: - View Controller
        
        container.storyboardInitCompleted(StatisticsViewController.self) { resolver, viewController in
            let viewModel = resolver.resolve(StatisticsViewModel.self)
            viewController.viewModel = viewModel
        }
    }
}
