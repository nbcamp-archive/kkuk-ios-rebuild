//
//  Category.swift
//  Kkuk
//
//  Created by 장가겸 on 10/26/23.
//

import RealmSwift

import Foundation

class Category: Object, Identifiable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var iconId: Int

    override static func primaryKey() -> String? {
        return "id"
    }
    
}
