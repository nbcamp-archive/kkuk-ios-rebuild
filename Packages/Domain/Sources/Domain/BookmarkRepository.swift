//
//  LinkMetadataRepository.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation

// MARK: - Abstraction
public protocol BookmarkRepository {
    func fetch() async throws -> [Bookmark]
}
