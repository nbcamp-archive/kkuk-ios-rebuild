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

// !!!: Command SwiftCompile failed with a nonzero exit code
// Swift 6의 엄격한 동시성 검사 때문에 에러가 발생함
// Thread-safe하지 않은 코드이고, Sendable 프로토콜을 준수해야 하지만,
// 우선 무시하고 나중에 고쳐야함
final class CategoryHelper: Storage, @unchecked Sendable {
    
    static let shared = CategoryHelper()

    private var database: Realm {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yujinkim1.Kkuk")
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
