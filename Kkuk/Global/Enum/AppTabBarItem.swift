//
//  AppTabBarItem.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import UIKit

enum AppTabBarItem: String, CaseIterable {
    
    case home, category, action, search, setting
    
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .category
        case 2: self = .action
        case 3: self = .search
        case 4: self = .setting
        default: return nil
        }
    }
    
    func toInt() -> Int {
        switch self {
        case .home: return 0
        case .category: return 1
        case .action: return 2
        case .search: return 3
        case .setting: return 4
        }
    }
    
    func toTabName() -> String {
        switch self {
        case .home: return "홈"
        case .category: return "카테고리"
        case .action: return ""
        case .search: return "검색"
        case .setting: return "설정"
        }
    }
    
    func toTabImage() -> UIImage {
        switch self {
        case .home: return Asset.home
        case .category: return Asset.category
        case .action: return Asset.action.withRenderingMode(.alwaysOriginal)
        case .search: return Asset.search
        case .setting: return Asset.setting
        }
    }
    
}
