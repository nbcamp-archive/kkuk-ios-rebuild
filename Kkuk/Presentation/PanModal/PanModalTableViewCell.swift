//
//  PanModalTableViewCell.swift
//  Kkuk
//
//  Created by 장가겸 on 10/25/23.
//

import SnapKit
import UIKit

class PanModalTableViewCell: BaseUITableViewCell {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀 라벨"
        label.font = .subtitle2
        label.textColor = .text1
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        contentView.addSubview(titleLabel)
        contentView.superview?.backgroundColor = .background
    }

    override func setLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(name: String) {
        if name == "취소" {
            titleLabel.textColor = .systemRed
        }
        titleLabel.text = name
    }
}
