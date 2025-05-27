//
//  LinkMetadata.swift
//  Domain
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation

public struct LinkMetadata: Sendable {
    public let id: UUID
    public let ogTitle: String
    public let ogDescription: String?
    public let ogImage: String?
    public let createdAt: Date
    
    public init(id: UUID, ogTitle: String, ogDescription: String? = nil, ogImage: String? = nil, createdAt: Date) {
        self.id = id
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.ogImage = ogImage
        self.createdAt = createdAt
    }
}
