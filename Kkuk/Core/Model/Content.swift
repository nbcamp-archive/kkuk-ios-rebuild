//
//  RealmContent.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/26.
//

import RealmSwift
import UIKit

class Content: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var sourceURL: String // [meta:og:url]
    @Persisted var title: String // [meta:og:title]
    @Persisted var imageURL: String? // [meta:og:image]
    @Persisted var memo: String?
    @Persisted var createDate: Date
    @Persisted var isPinned: Bool // default false
    @Persisted var categoryId: Int // default 0
    
    convenience init(id: String,
                     sourceURL: String,
                     title: String,
                     imageURL: String?,
                     memo: String?,
                     createDate: Date = Date(),
                     isPinned: Bool = false,
                     categoryId: Int = 0) {
        
        self.init()
        self.id = id
        self.sourceURL = sourceURL
        self.title = title
        self.imageURL = imageURL
        self.memo = memo
        self.createDate = createDate
        self.isPinned = isPinned
        self.categoryId = categoryId
    }
}

class ContetnManager {
    static let shared = ContetnManager()
    private let realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func add(to content: Content) {
        do {
            try realm.write {
                realm.add(content)
            }
        } catch {
            print("error realm")
        }
    }
    
    func read(at text: String) -> [Content] {
        do {
            let realm = try Realm()
            // 전체 불러오기
//            let content = realm.objects(Content.self)
//            for item in content {
//                print(item)
//            }

            let predicateQuery = NSPredicate(format: "title CONTAINS %@", text)
            let result = realm.objects(Content.self).filter(predicateQuery)
            let array: [Content] = Array(result)
            print(result)
            return array

        } catch {
            print("Error adding user: \(error)")
            return []
        }
    }
}
