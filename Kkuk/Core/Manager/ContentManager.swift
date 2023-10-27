//
//  ContentManager.swift
//  Kkuk
//
//  Created by t2023-m0062 on 2023/10/27.
//

import Foundation
import RealmSwift

class ContentManager {
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", try! Realm().configuration.fileURL!)
    }
    
    func create(content: Content) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(content) // Content객체를 Realm에 추가(저장)
            }
        } catch {
            print("Failed create ContentObject: \(error)")
        }
    }
    
    func read() -> [Content] {
        do {
            let realm = try Realm()
            let contents = realm.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false)
            return Array(contents)
        } catch {
            print("Failed read ContentObject: \(error)")
        }
        return []
    }
}
