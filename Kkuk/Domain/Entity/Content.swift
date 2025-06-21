//
//  Content.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/27.
//

import Foundation

// MARK: - DEPRECATED, Content, 2025-06-21
//
// DEP-004
// 로컬 데이터베이스에 저장되는 북마크 객체로 사용되었으나,
// 더 이상 사용하지 않습니다.
//
//class Content: Object, Identifiable {
//    @Persisted(primaryKey: true) var id: ObjectId
//    @Persisted var sourceURL: String
//    @Persisted var title: String
//    @Persisted var imageURL: String?
//    @Persisted var memo: String?
//    @Persisted var createDate: Date
//    @Persisted var isPinned: Bool
//    @Persisted var category: ObjectId
//    
//    override class func primaryKey() -> String? {
//        "id"
//    }
//    
//    convenience init(
//        sourceURL: String,
//        title: String,
//        imageURL: String?,
//        memo: String?,
//        createDate: Date = Date(),
//        isPinned: Bool = false,
//        category: ObjectId) {
//            self.init()
//            self.sourceURL = sourceURL
//            self.title = title
//            self.imageURL = imageURL
//            self.memo = memo
//            self.createDate = createDate
//            self.isPinned = isPinned
//            self.category = category
//        }
//}
