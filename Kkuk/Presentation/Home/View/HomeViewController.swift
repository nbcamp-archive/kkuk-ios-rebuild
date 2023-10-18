//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

class HomeViewController: BaseUIViewController {
    
    lazy var label: UILabel = UILabel().and {
        $0.text = "익스텐션 테스트"
        $0.font = .largeTitle
        $0.textColor = .main
    }
    
    override func setUI() {
        view.addSubview(label)
    }
    
    override func setLayout() {
        label.snp.makeConstraints { constraint in
            constraint.centerX.equalToSuperview()
            constraint.centerY.equalToSuperview()
        }
    }
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
}
