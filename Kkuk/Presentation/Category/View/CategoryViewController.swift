//
//  CategoryViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit
import SnapKit

class CategoryViewController: BaseUIViewController {
    
    private lazy var moveToAddCategoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("카테고리 추가하기", for: .normal)
        button.addTarget(self, action: #selector(moveToAddCategory), for: .touchUpInside)
        return button
    }()
    
    override func setUI() {
        view.addSubview(moveToAddCategoryButton)
    }
    
    override func setLayout() {
        moveToAddCategoryButton.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
    }
    
    @objc private func moveToAddCategory() {
        let customVC = AddCategoryViewController()
        let navController = UINavigationController(rootViewController: customVC)
        self.present(navController, animated: true, completion: nil)
    }
    
}
