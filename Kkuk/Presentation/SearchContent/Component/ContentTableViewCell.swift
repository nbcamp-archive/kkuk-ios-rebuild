//
//  ContentTableViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/18.
//

import UIKit

class ContentTableViewCell: BaseUITableViewCell {
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    private lazy var siteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사이트 타이틀 라벨"
        label.font = .subtitle2
        label.textColor = .text1
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모 라벨"
        label.font = .subtitle4
        label.textColor = .subgray2
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.text = "URL 라벨"
        label.font = .subtitle4
        label.textColor = .subgray2
        label.numberOfLines = 1
        return label
    }()
    
    func configureCell(title: String, memo: String?, image: UIImage?, url: String) {
        siteTitleLabel.text = title
        memoLabel.text = memo
        thumbnailImageView.image = image
        urlLabel.text = url
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    override func setUI() {
        contentView.addSubviews([thumbnailImageView, siteTitleLabel, memoLabel, urlLabel])
    }
    
    override func setLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.width.height.equalTo(68)
        }
        
        siteTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(siteTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
    }
}
