//
//  SceneDelegate.swift
//  Gamagu
//
//  Created by yona on 1/25/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let settingVC = UINavigationController(rootViewController: SettingViewController())
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([homeVC, settingVC], animated: true)
        tabBarController.setTabBar()
        
        preloadData()
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .dark
    }
    
    private func preloadData() {
        let preloadDataKey = "didPreloadData"
        
        if UserDefaults.standard.bool(forKey: preloadDataKey) == false {
            let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            backgroundContext.perform {
                CoreDataManager.shared.initialDataSetup()
                UserDefaults.standard.set(true, forKey: preloadDataKey)
            }
        }
    }
}

