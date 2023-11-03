//
//  ContentManager.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/27.
//

import Foundation
import RealmSwift

class ContentManager {
    func getLocationOfDefaultRealm() {
        do {
            let realm = try Realm()
            let filePath = realm.configuration.fileURL
            print("Realm is located at: ", filePath!)
        } catch {
            print("Faild load to realm file path in located.")
        }
    }
    
    func create(content: Content) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(content)
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
    
    func read(at column: SegmentMenu, with searchText: String) -> [Content] {       
        do {
            let realm = try Realm()
            let query = NSPredicate(format: "\(column) CONTAINS[c] %@", searchText)
            let result = realm.objects(Content.self).filter(query).sorted(byKeyPath: "createDate", ascending: false)
            return Array(result)
        } catch {
            print("Error adding user: \(error)")
            return []
        }
    }
    
    func update(content: Content, completion: @escaping (Content) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                completion(content)
            }
        } catch {
            print("Failed to update ContentObject: \(error)")
        }
    }
    
    func readInCategory(at id: ObjectId) -> [Content] {
        do {
            let realm = try Realm()
            let predicateQuery = NSPredicate(format: "category == %@", id)
            let contents = realm.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false).filter(predicateQuery)
            return Array(contents)
        } catch {
            print("Failed read ContentObject: \(error)")
        }
        return []
    }
    
}
