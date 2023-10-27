//
//  Category.swift
//  Kkuk
//
//  Created by 장가겸 on 10/26/23.
//

import Foundation
import RealmSwift

class Category: Object, Identifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String // 나만의 꿀자료
    @Persisted var iconId: Int // 0: 꽃, 1: 연필, 2: 고양이

    override static func primaryKey() -> String? {
        return "id"
    }
}
