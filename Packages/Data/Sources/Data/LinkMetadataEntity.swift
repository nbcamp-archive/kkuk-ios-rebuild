//
//  LinkMetadataEntity.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation
import SwiftData
import Domain

@Model
public final class LinkMetadataEntity {
    @Attribute(.unique) public var id: UUID
    public var ogTitle: String
    public var ogDescription: String?
    public var ogImage: String?
    public var createdAt: Date
    
    public init(id: UUID, ogTitle: String, ogDescription: String? = nil, ogImage: String? = nil, createdAt: Date) {
        self.id = id
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.ogImage = ogImage
        self.createdAt = createdAt
    }
}

// MARK: - 매핑
extension LinkMetadataEntity {
    func toDomain() -> LinkMetadata {
        .init(id: id, ogTitle: ogTitle, ogDescription: ogDescription, ogImage: ogImage, createdAt: createdAt)
    }
}

extension LinkMetadata {
    func toEntity() -> LinkMetadataEntity {
        .init(id: id, ogTitle: ogTitle, createdAt: createdAt)
    }
}
