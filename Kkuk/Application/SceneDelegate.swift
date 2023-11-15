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
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        updateAppearanceStyle()
    }
}

extension SceneDelegate {
    
    private func updateAppearanceStyle() {
        let defaults = UserDefaults.standard
        let themeMode = defaults.string(forKey: "app_appearance_style")
        
        if #available(iOS 15.0, *) {
            switch themeMode {
            case "light":
                window?.overrideUserInterfaceStyle = .light
                defaults.register(defaults: ["app_appearance_style" : "light"])
            case "dark":
                window?.overrideUserInterfaceStyle = .dark
                defaults.register(defaults: ["app_appearance_style" : "dark"])
            default:
                window?.overrideUserInterfaceStyle = .unspecified
                defaults.register(defaults: ["app_appearance_style" : "unspecified"])
            }
        }
    }
    
}
