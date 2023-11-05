//
//  RecentSearch.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/24.
//

import Foundation

struct RecentSearchHelper {
    
    var keyNmae: String {
        return String(describing: self)
    }
    
    func add(to search: String) {
        var allSearches = fetchAllSearches()
        
        if allSearches.count == 10 {
            allSearches.remove(at: 0)
        }
        
        allSearches.append(search)
        UserDefaults.standard.set(allSearches, forKey: keyNmae)
    }
    
    func fetchAllSearches() -> [String] {
        return UserDefaults.standard.stringArray(forKey: keyNmae) ?? []
    }
    
    func deleteAllSearches() {
        UserDefaults.standard.removeObject(forKey: keyNmae)
    }
    
    func deleteSearch(at index: Int) {
        var allSearches = fetchAllSearches()
        allSearches.remove(at: index)
        UserDefaults.standard.set(allSearches, forKey: keyNmae)
    }
    
}
