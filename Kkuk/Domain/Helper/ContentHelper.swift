//
//  ContentManager.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/27.
//

import RealmSwift

import Foundation

class ContentHelper {
    
    private var database: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.archive.nbcamp.Kkuk")
        
        let realmURL = container?.appendingPathComponent("default.realm")
        
        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
        
        do {
            return try Realm(configuration: config)
        } catch {
            fatalError("Error initializing Realm Service: \(error.localizedDescription)")
        }
    }
    
    private func databaseTransaction(_ action: () -> Void) {
        do {
            try database.write { action() }
        } catch {
            printError("Failed to perform database action: \(error.localizedDescription)")
        }
    }
    
    private func printError(_ message: String) {
        print(message)
    }
    
}

// MARK: - Realm Action

extension ContentHelper {
    
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
        databaseTransaction { database.add(content) }
    }
    
    func update(content: Content, completion: @escaping (Content) -> Void) {
        databaseTransaction { completion(content) }
    }
    
    func read() -> [Content] {
        let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false)
        
        return Array(contents)
    }
    
    func read(at column: SegmentMenu, with searchText: String) -> [Content] {
        let query = NSPredicate(format: "\(column) CONTAINS[c] %@", searchText)
        
        let result = database.objects(Content.self).filter(query).sorted(byKeyPath: "createDate", ascending: false)
        
        return Array(result)
    }
    
    func readInCategory(at id: ObjectId) -> [Content] {
        let predicateQuery = NSPredicate(format: "category == %@", id)
        
        let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false).filter(predicateQuery)
        
        return Array(contents)
    }
    
    func delete(_ content: Content) {
        databaseTransaction { database.delete(content) }
    }
    
}
