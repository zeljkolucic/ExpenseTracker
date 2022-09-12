//
//  SceneDelegate.swift
//  ExpenseTracker
//
//  Created by Željko Lučić on 7/11/22.
//

import UIKit
import SwinjectStoryboard

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var authenticationService: AuthenticationService?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        navigateToStoryboard("LaunchScreen")
        setInitialViewController()
    }
    
    // MARK: - Helpers

    fileprivate func setInitialViewController() {
        authenticationService = SwinjectStoryboard.provideAuthenticationService()
        DispatchQueue.main.async {
            if let isSignedIn = self.authenticationService?.isSignedIn(), isSignedIn {
                self.navigateToStoryboard("MainFlow")
            } else {
                self.navigateToStoryboard("LoginAndRegisterFlow")
            }
        }
    }
    
    fileprivate func navigateToStoryboard(_ storyboardIdentifier: String) {
        if storyboardIdentifier == "MainFlow" {
            let mainViewController = UIStoryboard(name: storyboardIdentifier, bundle: .main).instantiateInitialViewController()
            let loginViewController = UIStoryboard(name: "LoginAndRegisterFlow", bundle: .main).instantiateInitialViewController()
            
            if let mainViewController = mainViewController, let loginViewController = loginViewController {
                loginViewController.modalPresentationStyle = .overFullScreen
                loginViewController.view.isHidden = true
                mainViewController.modalPresentationStyle = .fullScreen
                
                window?.rootViewController?.present(loginViewController, animated: false)
                loginViewController.present(mainViewController, animated: false) {
                    loginViewController.view.isHidden = false
                }
            }
            
        } else {
            let storyboard = UIStoryboard(name: storyboardIdentifier, bundle: .main)
            window?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }

}

