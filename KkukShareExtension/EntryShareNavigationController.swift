//
//  EntryShareNavigationController.swift
//  KkukShareExtension
//
//  Created by 장가겸 on 11/8/23.
//

import UIKit

@objc(EntryShareNavigationController)
class EntryShareNavigationController: UINavigationController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.setViewControllers([ShareViewController()], animated: false)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
