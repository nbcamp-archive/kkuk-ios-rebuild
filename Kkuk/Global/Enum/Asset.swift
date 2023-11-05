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
    
    // MARK: - TabBarItem
    
    static var home: UIImage { .loadAsset(named: "lucide_home") }
    static var category: UIImage { .loadAsset(named: "lucide_category") }
    static var search: UIImage { .loadAsset(named: "lucide_search") }
    static var setting: UIImage { .loadAsset(named: "lucide_setting") }
    
    // MARK: - WebView
    
    static var backward: UIImage { .loadAsset(named: "lucide_left_arrow") }
    static var forward: UIImage { .loadAsset(named: "lucide_right_arrow") }
    static var safari: UIImage { .loadAsset(named: "lucide_safari") }
    static var share: UIImage { .loadAsset(named: "lucide_share") }
    
}
