//
//  RecentSearchContentCollectionViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/19.
//

import UIKit

class RecentSearchContentCollectionViewCell: BaseUICollectionViewCell {
    
    let manager = RecentSearchManager()
    
    private lazy var searchWordLabel: UILabel = {
        var label = UILabel()
        label.font = .body1
        label.textColor = .text1
        return label
    }()
    
    lazy var deleteButton: UIButton = {
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
            make.leading.greaterThanOrEqualTo(searchWordLabel.snp.trailing).offset(4)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height).dividedBy(2)
        }
    }
    
    func addSearchWordLabel(text: String) {
        searchWordLabel.text = text
    }
    
    func addDeleteButton(tag: Int) {
        deleteButton.tag = tag
    }
}
