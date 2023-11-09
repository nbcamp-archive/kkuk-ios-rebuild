//
//  RealmCategoryService.swift
//  Kkuk
//
//  Created by 장가겸 on 10/26/23.
//

import RealmSwift

import Foundation

protocol Storage {
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> Results<T>
}

final class CategoryHelper: Storage {
    
    static let shared = CategoryHelper()

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
    
    func getLocationOfDefaultRealm() {
        print("Realm is located at:", database.configuration.fileURL!)
    }
    
    func read() -> [Category] {
        let result = database.objects(Category.self)
        let array: [Category] = Array(result)
        return array
    }
    
    func read(at categoryId: ObjectId) -> Category? {
        do {
            let query = NSPredicate(format: "id == %@", categoryId)
            let result = database.objects(Category.self).filter(query).first
            return result
        }
    }
    
    func write<T: Object>(_ object: T) {
        do {
            try database.write {
                database.add(object, update: .modified)
            }
            
        } catch {
            print(error)
        }
    }
    
    func update<T: Object>(_ object: T, completion: @escaping ((T) -> Void)) {
        do {
            try database.write {
                completion(object)
            }
        } catch {
            print(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try database.write {
                database.delete(object)
                print("Delete Success")
            }
            
        } catch {
            print(error)
        }
    }

    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool = true) -> Results<T> {
        return database.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
    }
}
