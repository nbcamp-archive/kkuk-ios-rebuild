//
//  SegmentMenu.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/11/06.
//

import Foundation

enum SegmentMenu: Int {
    case title
    case memo

    var name: String {
        switch self {
        case .title: return "사이트"
        case .memo: return "메모"
        }
    }

    var column: String {
        switch self {
        case .title: return "title"
        case .memo: return "memo"
        }
    }
}
