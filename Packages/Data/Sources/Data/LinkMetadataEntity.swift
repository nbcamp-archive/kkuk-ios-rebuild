//
//  LinkMetadataEntity.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation
import SwiftData

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
