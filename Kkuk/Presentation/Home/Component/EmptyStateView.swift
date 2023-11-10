//
//  EmptyStateView.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/24.
//

import UIKit

class EmptyStateView: UIView {
    private var emptyStateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = "콘텐츠를 고정해주세요."
        label.font = .subtitle1
        label.textColor = .background
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews([emptyStateImageView, emptyStateLabel])
        setLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        emptyStateImageView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview().offset(12)
            constraint.leading.trailing.equalToSuperview()
        }
        
        emptyStateLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(emptyStateImageView.snp.bottom).offset(14)
            constraint.centerX.bottom.equalToSuperview()
        }
    }
}
