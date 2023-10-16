//
//  AppTabBarController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class AppTabBarController: BaseUITabBarController {
    
    override func setTabBar() {
        let homeViewController = HomeViewController()
        let categoryViewController = CategoryViewController()
        let searchContentViewController = SearchContentViewController()
        let appInfoViewController = AppInfoViewController()
        
        viewControllers = [homeViewController, categoryViewController,
                           searchContentViewController, appInfoViewController]
        
        homeViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home_tab_icon"), selectedImage: nil)
        categoryViewController.tabBarItem = UITabBarItem(title: "카테고리", image: UIImage(named: "category_tab_icon"), selectedImage: nil)
        searchContentViewController.tabBarItem = UITabBarItem(title: "검색", image: UIImage(named: "search_tab_icon"), selectedImage:nil)
        appInfoViewController.tabBarItem = UITabBarItem(title:"앱 정보" ,image:UIImage(named:"info_tab_icon") ,selectedImage:nil)
    }
    
}
