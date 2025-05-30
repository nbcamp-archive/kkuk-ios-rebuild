//
//  BookmarkEntity.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-30.
//

import Foundation
import SwiftData
import Domain

@Model
public class BookmarkEntity {
    @Attribute(.unique) public var id: UUID // 고유번호
    public var createdAt: Date // 생성일
    public var type: String = "bookmark" // 유형
    public var ogUrl: String // og:url
    public var ogTitle: String // og:title
    public var ogDescription: String? // og:description
    public var ogImage: String? // og:image
    
    public init(
        id: UUID,
        createdAt: Date,
        type: String,
        ogUrl: String,
        ogTitle: String,
        ogDescription: String? = nil,
        ogImage: String? = nil) {
            self.id = id
            self.createdAt = createdAt
            self.type = type
            self.ogUrl = ogUrl
            self.ogTitle = ogTitle
            self.ogDescription = ogDescription
            self.ogImage = ogImage
        }
}

// MARK: - Identifiable
extension BookmarkEntity: Identifiable {}

// MARK: - Hashable
extension BookmarkEntity: Hashable {
    public static func == (lhs: BookmarkEntity, rhs: BookmarkEntity) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Mapper
extension BookmarkEntity {
    static func toModel(_ entity: BookmarkEntity) -> Bookmark {
        return .init(
            id: entity.id,
            createdAt: entity.createdAt,
            type: entity.type,
            ogUrl: entity.ogUrl,
            ogTitle: entity.ogTitle,
            ogDescription: entity.ogDescription,
            ogImage: entity.ogImage
        )
    }
    
    static func toEntity(_ model: Bookmark) -> BookmarkEntity {
        return .init(
            id: model.id,
            createdAt: model.createdAt,
            type: model.type,
            ogUrl: model.ogUrl,
            ogTitle: model.ogTitle,
            ogDescription: model.ogDescription,
            ogImage: model.ogImage
        )
    }
}
