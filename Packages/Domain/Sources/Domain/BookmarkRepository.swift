//
//  LinkMetadataRepository.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-28.
//

import Foundation

// MARK: - Abstraction
public protocol BookmarkRepository {
    func fetchAll() async throws -> [LinkMetadata]
}
