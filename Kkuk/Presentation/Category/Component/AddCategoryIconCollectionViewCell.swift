//
//  AddCategoryIconCollectionViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/11/09.
//

import UIKit

class AddCategoryIconCollectionViewCell: BaseUICollectionViewCell {
    
    lazy var iconButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    override func setUI() {
        contentView.addSubview(iconButton)
    }
    
    override func setLayout() {
        iconButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(contentView.snp.height)
        }
    }
    
    func configuration(index: Int) {
        iconButton.setImage(Asset.iconImageList[index], for: .normal)
    }
}
