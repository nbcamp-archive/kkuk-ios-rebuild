//
//  SceneDelegate.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-15.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        window?.makeKeyAndVisible()
        window?.rootViewController = AppTabBarController()
        
        let key: String = "isFirstLaunch"
        
        let isFirstLaunch = UserDefaults.standard.bool(forKey: key)
        
        if !isFirstLaunch {
            var unclassifiedCategory = Category()
            unclassifiedCategory.name = "미분류"
            unclassifiedCategory.iconId = 0
            CategoryHelper.shared.write(unclassifiedCategory)
            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
