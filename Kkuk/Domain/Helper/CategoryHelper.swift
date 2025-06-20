//
//  RealmCategoryService.swift
//  Kkuk
//
//  Created by 장가겸 on 10/26/23.
//

import Foundation

// MARK: - DEPRECATED, Storage, 2025-06-20
//
// DEP-002
// Realm 데이터베이스 CRUD 기능에 대한 추상화 프로토콜입니다.
// 더 이상 사용하지 않습니다.
//
//protocol Storage {
//    func write<T: Object>(_ object: T)
//    func delete<T: Object>(_ object: T)
//    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool) -> Results<T>
//}

// MARK: - DEPRECATED, CategoryHelper, 2025-06-20
//
// DEP-003
// 카테고리 읽기, 쓰기, 정렬하기, 삭제하기 기능을 담당했던 클래스입니다.
// 이 클래스 인스턴스가 사용되는 시점에 Realm도 다시 호출하는 문제도 있습니다.
// 앞으로 Swift Data로 대체될 것이므로 더 이상 사용하지 않습니다.
//
//final class CategoryHelper: Storage, @unchecked Sendable {
//    static let shared = CategoryHelper()
//
//    private var database: Realm {
//        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yujinkim1.Kkuk")
//        let realmURL = container?.appendingPathComponent("default.realm")
//        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
//      
//        do {
//            return try Realm(configuration: config)
//        } catch {
//            fatalError("Error initializing Realm: \(error)")
//        }
//    }
//    
//    func getLocationOfDefaultRealm() {
//        print("Realm is located at:", database.configuration.fileURL!)
//    }
//    
//    func read() -> [Category] {
//        let result = database.objects(Category.self)
//        let array: [Category] = Array(result)
//        return array
//    }
//    
//    func read(at categoryId: ObjectId) -> Category? {
//        do {
//            let query = NSPredicate(format: "id == %@", categoryId)
//            let result = database.objects(Category.self).filter(query).first
//            return result
//        }
//    }
//    
//    func write<T: Object>(_ object: T) {
//        do {
//            try database.write {
//                database.add(object, update: .modified)
//            }
//            
//        } catch {
//            print(error)
//        }
//    }
//    
//    func update<T: Object>(_ object: T, completion: @escaping ((T) -> Void)) {
//        do {
//            try database.write {
//                completion(object)
//            }
//        } catch {
//            print(error)
//        }
//    }
//    
//    func delete<T: Object>(_ object: T) {
//        do {
//            try database.write {
//                database.delete(object)
//                print("Delete Success")
//            }
//            
//        } catch {
//            print(error)
//        }
//    }
//
//    func sort<T: Object>(_ object: T.Type, by keyPath: String, ascending: Bool = true) -> Results<T> {
//        return database.objects(object).sorted(byKeyPath: keyPath, ascending: ascending)
//    }
//}
