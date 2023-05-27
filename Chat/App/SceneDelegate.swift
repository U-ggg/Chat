//
//  SceneDelegate.swift
//  Chat
//
//  Created by sidzhe on 03.05.2023.
//

import UIKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowsScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowsScene)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
    }
}

