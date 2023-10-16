//
//  BaseUITabBarController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class BaseUITabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTabBar()
    }
    
    func setUI() {
        let tabBarAppearence = UITabBarAppearance()
        tabBarAppearence.configureWithOpaqueBackground()
        tabBarAppearence.backgroundColor = UIColor.white
        
        tabBar.standardAppearance = tabBarAppearence
        tabBar.scrollEdgeAppearance = tabBarAppearence
        tabBar.tintColor = UIColor.black
    }
    
    func setTabBar() {}
    
}
