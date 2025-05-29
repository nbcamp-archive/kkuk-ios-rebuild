//
//  DefaultBookmarkRepository.swift
//  Data
//
//  Created by Yujin Kim on 2025-05-29.
//

import Foundation
import SwiftData
import Domain

final class DefaultBookmarkRepository: BookmarkRepository {
    // fetch, insert, delete, save가 가능한 SwiftData 객체
    private let modelContext: ModelContext
    
    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch() async throws -> [Domain.Bookmark] {
        let sortDescriptor = SortDescriptor(\Bookmark.createdAt, order: .reverse)
        let fetchDescriptor = FetchDescriptor<Bookmark>(sortBy: [sortDescriptor])
        
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            return result
        } catch {
            print("\(SwiftDataError.missingModelContext.localizedDescription)")
        }
        
        return []
    }
}
