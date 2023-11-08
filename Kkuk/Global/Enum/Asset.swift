//
//  Asset.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import UIKit

enum Asset {
    
    // MARK: - NavigationBar
    
    static var back: UIImage { .loadAsset(named: "lucide_chevron_left") }
    static var refresh: UIImage { .loadAsset(named: "lucide_rotate") }
    
    // MARK: - AddContentView
    
    static var redirectAddCategory: UIImage { .loadAsset(named: "lucide_folder_plus") }
    
    // MARK: - AddCategoryView
    
    static var animal: UIImage { .loadAsset(named: "animal") }
    static var baby: UIImage { .loadAsset(named: "baby") }
    static var beauty: UIImage { .loadAsset(named: "beauty") }
    static var book: UIImage { .loadAsset(named: "book") }
    static var cafe: UIImage { .loadAsset(named: "cafe") }
    static var car: UIImage { .loadAsset(named: "car") }
    static var culture: UIImage { .loadAsset(named: "culture") }
    static var education: UIImage { .loadAsset(named: "education") }
    static var exercise: UIImage { .loadAsset(named: "exercise") }
    static var fashion: UIImage { .loadAsset(named: "fashion") }
    static var finance: UIImage { .loadAsset(named: "finance") }
    static var food: UIImage { .loadAsset(named: "food") }
    static var health: UIImage { .loadAsset(named: "health") }
    static var interier: UIImage { .loadAsset(named: "interier") }
    static var tech: UIImage { .loadAsset(named: "tech") }
    static var kitchen: UIImage { .loadAsset(named: "kitchen") }
    static var music: UIImage { .loadAsset(named: "music") }
    static var plant: UIImage { .loadAsset(named: "plant") }
    static var shopping: UIImage { .loadAsset(named: "shopping") }
    static var trip: UIImage { .loadAsset(named: "trip") }
    
    // MARK: - CategoryInnerView
    
    static var editCategory: UIImage { .loadAsset(named: "lucide_circle_ellipsis") }
    
    // MARK: - CategoryView
    
    static var addCategory: UIImage { .loadAsset(named: "lucide_folder_plus_white") }
    
    // MARK: - TabBarItem
    
    static var home: UIImage { .loadAsset(named: "lucide_home") }
    static var category: UIImage { .loadAsset(named: "lucide_category") }
    static var action: UIImage { .loadAsset(named: "lucide_plus_action") }
    static var search: UIImage { .loadAsset(named: "lucide_search") }
    static var setting: UIImage { .loadAsset(named: "lucide_setting") }
    
    // MARK: - WebView
    
    static var backward: UIImage { .loadAsset(named: "lucide_left_arrow") }
    static var forward: UIImage { .loadAsset(named: "lucide_right_arrow") }
    static var safari: UIImage { .loadAsset(named: "lucide_safari") }
    static var share: UIImage { .loadAsset(named: "lucide_share") }
    
}
