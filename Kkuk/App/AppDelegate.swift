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
        // Container for newly created App Group Identifier
        // !!!: 커스텀 FileManager.default 경로에 접근하지 못하는 문제가 발생
        // forSecurityApplicationGroupIdentifier 인자값을 수정해 우선적으로 해결함
        // 컨테이너가 nil인지 확인하는 코드로 변경함
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yujinkim1.Kkuk") else {
            fatalError("App Group 컨테이너가 존재하지 않습니다.")
        }
        // Shared path of realm config
        let realmUrl = container.appendingPathComponent("default.realm")
        let defaultRealmUrl = Realm.Configuration.defaultConfiguration.fileURL!
        // Config init
        var config = Realm.Configuration(fileURL: realmUrl, schemaVersion: 1)

        // Checking the old realm config is exist
        if FileManager.default.fileExists(atPath: defaultRealmUrl.path) {
            do {
                // Replace old config with the new one
                _ = try FileManager.default.replaceItemAt(realmUrl, withItemAt: defaultRealmUrl)
            } catch {
               print("Realm 마이그레이션 실패: \(error)")
            }
        }

        // Lastly init realm config to default config
        // 경로 설정 반영 후 초기화 테스트
        Realm.Configuration.defaultConfiguration = config
        do {
            // 초기화하는 과정에서 에러 확인
            _ = try Realm()
            print("Realm 초기화 성공")
        } catch {
            print("Realm 초기화 실패: \(error)")
        }
        
        return true
    }
    
    // MARK: - UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
}
