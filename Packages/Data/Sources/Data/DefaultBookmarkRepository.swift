//
//  DefaultBookmarkRepository.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-29.
//

import Foundation
import SwiftData
import SwiftSoup
import Domain

final class DefaultBookmarkRepository: BookmarkRepository {
    // fetch, insert, delete, save가 가능한 SwiftData 객체
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func parseMetadata(from url: URL) async throws -> Domain.Bookmark {
        let document = try SwiftSoup.parse(url.absoluteString)
        let url = try document.select("meta[property=og:url]").attr("content")
        let title = try document.select("meta[property=og:title]").attr("content")
        let description = try document.select("meta[property=og:description]").attr("content")
        let image = try document.select("meta[property=og:image]").attr("content")
        
        return Bookmark(
            ogUrl: url,
            ogTitle: title,
            ogDescription: description,
            ogImage: image)
    }
    
    func fetch() async throws -> [Domain.Bookmark] {
        let sortDescriptor = SortDescriptor(\BookmarkEntity.createdAt, order: .reverse)
        let fetchDescriptor = FetchDescriptor<BookmarkEntity>(sortBy: [sortDescriptor])
        
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            return result.compactMap(BookmarkEntity.toModel(_:))
        } catch {
            print("\(SwiftDataError.missingModelContext.localizedDescription)")
        }
        
        return []
    }
    
    // id 충돌만 일어나지 않으면 중복으로 추가해도 됨
    // 따로 update하거나 save할 필요 없이 단순하게 저장만 하도록 구현해야함
    func save(_ bookmark: Bookmark) async throws {
        // Bookmark 모델을 SwiftData 전용 모델로 매핑
        let entity = BookmarkEntity.toEntity(bookmark)

        do {
            modelContext.insert(entity) // 데이터 추가
            try modelContext.save() // 저장
        } catch {
            print("\(#function)에러: \(error.localizedDescription)")
        }
    }
    
    // 선택한 id의 데이터를 삭제함
    func delete(_ bookmark: Bookmark) async throws {
        // FetchDescriptor의 Predicate 매크로를 사용해 id로 매칭되는 데이터를 찾음
        let fetchDescriptor = FetchDescriptor<BookmarkEntity>(
            predicate: #Predicate{ $0.id == bookmark.id }
        )
        
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            result.forEach { modelContext.delete($0) } // 데이터 삭제
            try modelContext.save() // 저장
        } catch {
            print("\(#function)에러: \(error.localizedDescription)")
        }
    }
}
