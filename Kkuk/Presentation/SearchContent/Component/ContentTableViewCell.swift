//
//  ContentTableViewCell.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/18.
//

import UIKit

protocol ContentTableViewCellDelegate: AnyObject {
    func togglePin(index: Int)
}

class ContentTableViewCell: BaseUITableViewCell {
    weak var delegate: ContentTableViewCellDelegate?
    
    private var contentManager = ContentManager()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
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
        label.textColor = .subgray1
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.text = "URL 라벨"
        label.font = .subtitle4
        label.textColor = .subgray1
        label.numberOfLines = 1
        return label
    }()
    
    // pin 기능을 연결하기 위한 임시 버튼
    // 향후 컨텐츠 수정 및 삭제 등과 연결해서 변경 예정
    private lazy var pinButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tappedPinButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    func configureCell(title: String, memo: String?, image: String?, url: String, isPinned: Bool, index: Int) {
        thumbnailImageView.image = UIImage(systemName: "photo")
        siteTitleLabel.text = title
        memoLabel.text = memo
        urlLabel.text = url
        pinButton.tag = index
        let pinImage = isPinned ? UIImage(named: "selectedPin") : UIImage(named: "Pin")
        pinButton.setImage(pinImage, for: .normal)
        
        DispatchQueue.global().async {
            guard let url = URL(string: image ?? ""),
                  let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.thumbnailImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    override func setUI() {
        contentView.addSubviews([thumbnailImageView, siteTitleLabel, memoLabel, urlLabel, pinButton])
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
            make.trailing.equalToSuperview()
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(siteTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(4)
            make.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(pinButton.snp.leading).offset(-12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        pinButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.height.equalTo(16)
            make.centerY.equalTo(urlLabel)
        }
    }

    @objc func tappedPinButton(_ sender: UIButton) {
        delegate?.togglePin(index: sender.tag)
    }
}
