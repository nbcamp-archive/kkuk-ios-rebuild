//
//  SettingItemCell.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/25.
//

import UIKit

class SettingItemCell: UITableViewCell {
    static let identifier = "SettingItemCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textColor = .text1
        
        return label
    }()
    
    private var chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.right")
        view.tintColor = .text1
        return view
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .title2
        label.textColor = .text1
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        self.separatorInset = .zero
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, subTitle: String? = nil) {
        if let subTitle = subTitle {
            subTitleLabel.text = subTitle
            chevronImageView.isHidden = true
        }
        
        titleLabel.text = title
    }
    
    private func setLayout() {
        addSubviews([titleLabel, chevronImageView, separatorView, subTitleLabel])
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.leading.trailing.equalToSuperview()
            constraint.top.bottom.equalToSuperview().inset(14)
        }
        
        chevronImageView.snp.makeConstraints { constraint in
            constraint.trailing.centerY.equalToSuperview()
            constraint.width.height.equalTo(16)
        }
        
        subTitleLabel.snp.makeConstraints { constraint in
            constraint.trailing.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { constraint in
            constraint.height.equalTo(0.7)
            constraint.leading.trailing.equalToSuperview()
            constraint.bottom.equalToSuperview()
        }
    }
}
