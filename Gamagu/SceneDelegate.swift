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
        
        UNUserNotificationCenter.current().delegate = self
        
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
    
    func sceneDidEnterBackground(_ scene: UIScene) {
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

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner, .list, .sound])
    }
}
