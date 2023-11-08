//
//  PanModalOption.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/11/07.
//

import Foundation

struct PanModalOption {
    enum ScreenType {
        case category
        case content
    }
    
    enum Title: String {
        case modify = "수정"
        case delete = "삭제"
        case share = "공유"
        case cancel = "취소"
    }
    
    let screenType: ScreenType
    let title: [Title]
}
