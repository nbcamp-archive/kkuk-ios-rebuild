//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class HomeViewController: BaseUIViewController {
    
    lazy var label: UILabel = UILabel().and {
        $0.text = "텍스트"
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    lazy var test = UILabel().and {
        $0.text = ""
    }
    
    override func setUI() {}
    
    override func setLayout() {}
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
}
