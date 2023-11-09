//
//  ContentManager.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/27.
//

import RealmSwift

import Foundation

class ContentHelper {
    
    func getLocationOfDefaultRealm() {
        do {
            let realm = try Realm()
            let filePath = realm.configuration.fileURL
            print("Realm is located at: ", filePath!)
        } catch {
            print("Faild load to realm file path in located.")
        }
    }
    
    private var database: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.archive.nbcamp.Kkuk")
        let realmURL = container?.appendingPathComponent("default.realm")
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        do {
            return try Realm(configuration: config)
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func create(content: Content) {
        do {
            try database.write {
                database.add(content)
            }
        } catch {
            print("Failed create ContentObject: \(error)")
        }
    }
    
    func read() -> [Content] {
        do {
            let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false)
            return Array(contents)
        } catch {
            print("Failed read ContentObject: \(error)")
        }
        return []
    }
    
    func read(at column: SegmentMenu, with searchText: String) -> [Content] {       
        do {
            let query = NSPredicate(format: "\(column) CONTAINS[c] %@", searchText)
            let result = database.objects(Content.self).filter(query).sorted(byKeyPath: "createDate", ascending: false)
            return Array(result)
        } catch {
            print("Error adding user: \(error)")
            return []
        }
    }
    
    func update(content: Content, completion: @escaping (Content) -> Void) {
        do {
            try database.write {
                completion(content)
            }
        } catch {
            print("Failed to update ContentObject: \(error)")
        }
    }
    
    func readInCategory(at id: ObjectId) -> [Content] {
        do {
            let predicateQuery = NSPredicate(format: "category == %@", id)
            let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false).filter(predicateQuery)
            return Array(contents)
        } catch {
            print("Failed read ContentObject: \(error)")
        }
        return []
    }
    
    func delete(_ content: Content) {
        do {
            try database.write {
                database.delete(content)
            }
        } catch {
            print("Failed read ContentObject: \(error)")
        }
    }
}
