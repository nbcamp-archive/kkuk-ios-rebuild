//
//  ContentManager.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/27.
//

import Foundation

// MARK: - DEPRECATED, ContentHelper, 2025-06-20
//
// DEP-001
// 이전에는 RealmSwift 의존성을 통해 로컬 데이터베이스 처리를 위해 사용했으나,
// 앞으로 로컬 데이터베이스는 Swift Data로 대체될 것이므로 더 이상 사용하지 않습니다.
//
//class ContentHelper {
//    private var database: Realm {
//        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.yujinkim1.Kkuk")
//
//        let realmURL = container?.appendingPathComponent("default.realm")
//
//        let config = Realm.Configuration(fileURL: realmURL, schemaVersion: 1)
//
//        do {
//            return try Realm(configuration: config)
//        } catch {
//            fatalError("Error initializing Realm Service: \(error.localizedDescription)")
//        }
//    }
//
//    private func databaseTransaction(_ action: () -> Void) {
//        do {
//            try database.write { action() }
//        } catch {
//            printError("Failed to perform database action: \(error.localizedDescription)")
//        }
//    }
//
//    private func printError(_ message: String) {
//        print(message)
//    }
//}
//
//extension ContentHelper {
//    func getLocationOfDefaultRealm() {
//        do {
//            let realm = try Realm()
//
//            let filePath = realm.configuration.fileURL
//            print("Realm is located at: ", filePath!)
//        } catch {
//            print("Faild load to realm file path in located.")
//        }
//    }
//
//    func create(content: Content) {
//        databaseTransaction { database.add(content) }
//    }
//
//    func update(content: Content, completion: @escaping (Content) -> Void) {
//        databaseTransaction { completion(content) }
//    }
//
//    func read() -> [Content] {
//        let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false)
//
//        return Array(contents)
//    }
//
//    func read(at column: SegmentMenu, with searchText: String) -> [Content] {
//        var query = NSPredicate(format: "\(column) CONTAINS[c] %@", searchText)
//
//        if column == .title {
//            let urlQuery = NSPredicate(format: "sourceURL CONTAINS[c] %@", searchText)
//            query = NSCompoundPredicate(orPredicateWithSubpredicates: [query, urlQuery])
//        }
//
//        let result = database.objects(Content.self).filter(query).sorted(byKeyPath: "createDate", ascending: false)
//
//        return Array(result)
//    }
//
//    func readInCategory(at id: ObjectId) -> [Content] {
//        let predicateQuery = NSPredicate(format: "category == %@", id)
//
//        let contents = database.objects(Content.self).sorted(byKeyPath: "createDate", ascending: false).filter(predicateQuery)
//
//        return Array(contents)
//    }
//
//    func delete(_ content: Content) {
//        databaseTransaction { database.delete(content) }
//    }
//
//    func isAlreadyArchived(with URL: String) -> Bool {
//        let validationSet = read()
//        return validationSet.contains { $0.sourceURL == URL }
//    }
//}
