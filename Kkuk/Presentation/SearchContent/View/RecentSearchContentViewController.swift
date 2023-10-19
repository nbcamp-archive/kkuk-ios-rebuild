//
//  RecentSearchContentViewController.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/18.
//

import UIKit

class RecentSearchContentViewController: BaseUIViewController {
    private lazy var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .text1
        label.font = .subtitle2
        label.textAlignment = .left
       
        return label
    }()

    override func setUI() {
        view.addSubviews([recentSearchesLabel])

    }
    
    override func setLayout() {
        setRecentSearchesLabel()
    }
    
    func setRecentSearchesLabel() {
        recentSearchesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

}
