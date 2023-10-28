//
//  SetCategoryCell.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-28.
//

import UIKit

class SetCategoryCell: BaseUICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .body2
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .main : .clear
        }
    }
    
    override func setUI() {
        contentView.addSubview(nameLabel)
    }
    
    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(with category: Category) {
        nameLabel.text = category.name
    }
    
}
