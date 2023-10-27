//
//  SettingItemCell.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/25.
//

import UIKit
import SnapKit

class SettingItemCell: UITableViewCell {
    
    static let identifier = "SettingItemCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black // 색상 조정
        label.font = UIFont.subtitle2 // 글꼴 및 크기 조정
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black // 색상 조정
        label.font = UIFont.subtitle2// 글꼴 및 크기 조정
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
           }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureCell(title: String, subTitle: String? = nil) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
        // 부제목이 없으면 숨기기
        subTitleLabel.isHidden = subTitle == nil
    }
}
