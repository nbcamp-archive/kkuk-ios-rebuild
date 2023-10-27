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
        label.textColor = .black // 색상 조정
        label.font = UIFont.subtitle2 // 글꼴 및 크기 조정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black // 색상 조정
        label.font = UIFont.subtitle2// 글꼴 및 크기 조정
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
        self.separatorInset = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
    }
    
    private func setupLayout() {
        // titleLabel layout
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        // subTitleLabel layout
        NSLayoutConstraint.activate([
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            subTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configureCell(title: String, subTitle: String? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        // 부제목이 없으면 숨기기
        subTitleLabel.isHidden = subTitle == nil
    }
}
