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
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            iconImageView.alpha = isSelected ? 0.5 : 1.0
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
    }
    
    func configuration(index: Int) {
        iconImageView.image = Asset.iconImageList[index]
    }
}
