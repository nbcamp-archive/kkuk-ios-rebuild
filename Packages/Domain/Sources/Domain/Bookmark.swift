//
//  LinkMetadata.swift
//  Domain
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation

public struct Bookmark {
    public let id: UUID
    public let createdAt: Date
    public let type: String
    public let ogUrl: String
    public let ogTitle: String
    public let ogDescription: String?
    public let ogImage: String?
    
    public init(
        id: UUID = UUID(),
        createdAt: Date = .now,
        type: String = "bookmark",
        ogUrl: String,
        ogTitle: String,
        ogDescription: String?,
        ogImage: String?) {
        self.id = id
        self.createdAt = createdAt
        self.type = type
        self.ogUrl = ogUrl
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.ogImage = ogImage
    }
}

// MARK: - Extensions
extension Bookmark: Identifiable {}

extension Bookmark: Equatable {}

extension Bookmark: Sendable {}
