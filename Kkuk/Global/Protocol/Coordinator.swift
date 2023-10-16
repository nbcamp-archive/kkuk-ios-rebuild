//
//  Coordinator.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-15.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    
}
