//
//  RecentSearchContentCollectionViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/19.
//

import UIKit

class RecentSearchContentCollectionViewCell: BaseUICollectionViewCell {
    
    private lazy var searchWordLabel: UILabel = {
        var label = UILabel()
        label.text = "검색어"
        label.font = .body1
        label.textColor = .text1
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .text1
        return button
    }()
    
    override func setUI() {
        contentView.addSubviews([searchWordLabel, deleteButton])
    }
    
    override func setLayout() {
        searchWordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
