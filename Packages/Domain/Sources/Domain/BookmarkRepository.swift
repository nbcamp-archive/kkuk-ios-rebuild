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
    func save(_ bookmark: Bookmark) async throws
    func delete(_ bookmark: Bookmark) async throws
    /// 오픈그래프 메타데이터를 파싱해서 Bookmark 모델을 생성
    /// - 북마크를 저장하기 위한 전처리 과정이라 BookmarkRepository에 포함
    /// - Parameter url: 메타데이터를 파싱할 URL
    func parseMetadata(from url: URL) async throws -> Bookmark
}
