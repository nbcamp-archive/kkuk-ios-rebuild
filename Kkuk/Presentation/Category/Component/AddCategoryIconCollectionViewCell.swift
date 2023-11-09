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
    
    func toggleOverlayView(isSelected: Bool) {
        iconImageView.subviews.forEach { if $0.tag == 999 { $0.removeFromSuperview() } }

        if isSelected {
            let overlayView = UIView(frame: iconImageView.frame)
            overlayView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            overlayView.layer.cornerRadius = overlayView.frame.height / 2
            overlayView.clipsToBounds = true
            overlayView.tag = 999 // 오버레이 뷰 구분을 위한 태그 설정
            iconImageView.addSubview(overlayView)
        }
    }
}
