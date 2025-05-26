//
//  AppTabBarController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let tabBarItemCases = AppTabBarItem.allCases
        
        let tabBarItems = tabBarItemCases.map { makeTabBarItem(from: $0) }
        
        let homeViewController = HomeViewController()
        let categoryViewController = CategoryViewController()
        let addContentViewController = UIViewController()
        let searchContentViewController = SearchContentViewController()
        let settingViewController = SettingViewController()
        // MARK: HostingViewController
        let hostingViewController = HostingTestViewController(rootView: HostingTestView())
        
        viewControllers = [hostingViewController, categoryViewController, addContentViewController, searchContentViewController, settingViewController]
            .enumerated().map { index, viewController in
                setTabBarItem(for: viewController, tabBarItem: tabBarItems[index])
            }
            .map { wrapNavigationController(from: $0) }
        
        prepareTabBarController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}

extension AppTabBarController {
    
    private func makeTabBarItem(from type: AppTabBarItem) -> UITabBarItem {
        let name = type.toTabName()
        let image = type.toTabImage()
        let tag = type.toInt()
        return UITabBarItem(title: name, image: image, tag: tag)
    }
    
    private func setTabBarItem(for viewController: UIViewController, tabBarItem: UITabBarItem) -> UIViewController {
        viewController.tabBarItem = tabBarItem
        return viewController
    }
    
    private func wrapNavigationController(from viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    private func prepareTabBarController() {
        setViewControllers(viewControllers, animated: false)
      
        selectedIndex = AppTabBarItem.home.toInt()
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        
        tabBar.isTranslucent = false
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
        tabBar.unselectedItemTintColor = .unselected
        tabBar.tintColor = .selected
    }
    
    private func presentAddContentViewController() {
        let viewController = AddContentViewController()
        // viewController.hidesBottomBarWhenPushed = true
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
}

extension AppTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }

        if selectedIndex == 2 {
            presentAddContentViewController()
            
            return false
        }

        return true
    }

}
