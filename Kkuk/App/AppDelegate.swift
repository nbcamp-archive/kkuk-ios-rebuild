//
//  AppDelegate.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-15.
//

import IQKeyboardManagerSwift
import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaultRealm = Realm.Configuration.defaultConfiguration.fileURL!
        // Container for newly created App Group Identifier
        // !!!: 커스텀 FileManager.default 경로에 접근하지 못하는 문제가 발생
        // forSecurityApplicationGroupIdentifier 인자값을 수정해 우선적으로 해결함
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yujinkim1.Kkuk")
        // Shared path of realm config
        let realmURL = container?.appendingPathComponent("default.realm")
        // Config init
        var config: Realm.Configuration!

        // Checking the old realm config is exist
        if FileManager.default.fileExists(atPath: defaultRealm.path) {
            do {
              // Replace old config with the new one
                _ = try FileManager.default.replaceItemAt(realmURL!, withItemAt: defaultRealm)

               config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
            } catch {
               print("Error info: \(error)")
            }
        } else {
             config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        }

        // Lastly init realm config to default config
        Realm.Configuration.defaultConfiguration = config
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
}
