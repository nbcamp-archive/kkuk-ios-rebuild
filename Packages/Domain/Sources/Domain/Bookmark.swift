//
//  LinkMetadata.swift
//  Domain
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation
import SwiftData

@Model
public final class Bookmark: Identifiable, Hashable {
    public var id: UUID // 고유번호
    public var type: String = "link" // 유형
    public var createdAt: String // 생성일
    public var ogUrl: String // og:url
    public var ogTitle: String // og:title
    public var ogDescription: String? // og:description
    public var ogImage: String? // og:image
    
    public init(
        id: UUID,
        type: String,
        createdAt: String,
        ogUrl: String,
        ogTitle: String,
        ogDescription: String? = nil,
        ogImage: String? = nil) {
        self.id = id
        self.type = type
        self.createdAt = createdAt
        self.ogUrl = ogUrl
        self.ogTitle = ogTitle
        self.ogDescription = ogDescription
        self.ogImage = ogImage
    }
}
