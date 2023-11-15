//
//  AddCategoryIconCollectionViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/11/09.
//

import UIKit

class AddCategoryIconCollectionViewCell: BaseUICollectionViewCell {
    
    lazy var iconImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            iconImageView.layer.borderWidth = isSelected ? 4.0 : 0
            iconImageView.layer.borderColor = isSelected ? UIColor.selected.cgColor : nil
        }
    }
    
    override func setUI() {
        contentView.addSubview(iconImageView)
    }
    
    override func setLayout() {
        iconImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height)
        }
        
        contentView.layoutIfNeeded()
        iconImageView.layer.cornerRadius = iconImageView.frame.size.height / 2
    }
    
    func configuration(index: Int) {
        iconImageView.image = Asset.iconImageList[index]
        iconImageView.layer.cornerRadius = contentView.frame.size.height / 2
    }
}
