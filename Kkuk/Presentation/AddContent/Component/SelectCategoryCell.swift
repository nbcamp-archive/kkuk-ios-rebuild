//
//  SelectCategoryCell.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-28.
//

import UIKit

class SelectCategoryCell: BaseUICollectionViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text1
        label.font = .body2
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? .white : .text1
            backgroundColor = isSelected ? .main : .clear
            layer.borderColor = isSelected ? UIColor.main.cgColor : UIColor.subgray3.cgColor
        }
    }
    
    override func setUI() {
        layer.borderWidth = CGFloat(2)
        layer.borderColor = UIColor.subgray3.cgColor
        layer.cornerRadius = CGFloat(8)
        contentView.addSubview(nameLabel)
    }
    
    override func setLayout() {
        nameLabel.snp.makeConstraints {
            $0.edges.centerX.equalToSuperview().inset(4)
            $0.edges.centerY.equalToSuperview().inset(4)
        }
    }
    
    func configure(with category: Category) {
        nameLabel.text = category.name
    }
    
}
