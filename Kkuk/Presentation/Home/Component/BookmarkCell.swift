//
//  BookmarkCell.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/11/06.
//

import UIKit
import RealmSwift

protocol BookmarkCellDelegate: AnyObject {
    func removePin(id: ObjectId)
}

final class BookmarkCell: UICollectionViewCell {
    static let identifier = "BookmarkCell"
    
    private var item: Content?
    
    weak var delegate: BookmarkCellDelegate?
    
    private var contentManager = ContentHelper()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "emptyBoard")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .subgray3
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.subgray2.cgColor
        view.layer.borderWidth = 0.7
        
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .subtitle2
        
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.subgray3.cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    private lazy var pinButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "selectedPin"), for: .normal)
        button.addTarget(self, action: #selector(tapPinButton), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        
        addSubviews([imageView, circleView, pinButton, contentLabel])
        setLayout()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.top.equalToSuperview()
        }

        contentLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(imageView.snp.bottom).offset(8)
            constraint.horizontalEdges.equalToSuperview().inset(14)
            constraint.bottom.equalToSuperview().offset(-8)
            constraint.height.equalTo(40)
        }
        
        circleView.snp.makeConstraints { constraint in
            constraint.trailing.equalTo(-11)
            constraint.width.height.equalTo(30)
            constraint.top.equalTo(imageView.snp.top).offset(10)
        }
        
        pinButton.snp.makeConstraints { constraint in
            constraint.centerX.equalTo(circleView.snp.centerX)
            constraint.centerY.equalTo(circleView.snp.centerY)
            constraint.height.equalTo(18)
            constraint.width.equalTo(12)
        }
    }
    
    func configureCell(content: Content) {
        self.item = content
        self.contentLabel.text = content.title
        self.contentLabel.font = .subtitle2
        
        setUpImage(imageURL: content.imageURL)
    }
    
    func setUpImage(imageURL: String?) {
        guard var url = imageURL else { return }

        // http 포함 -> https로 변경
        if url.contains("http:") {
            if let range = url.range(of: "http:") {
                url.replaceSubrange(range, with: "https:")
            }
        // http 미포함 -> https를 접두에 추가
        // (이 조건은 https가 포함되어 있을 때도 만족하기 떄문에 조건에서 제거해줘야함)
        } else if !url.contains("https:") {
            url = "https:" + url
        }
        
        guard let https = url.range(of: "https:") else { return }
  
        url = String(url.suffix(from: https.lowerBound))

        guard let urlSource = URL(string: url) else { return }
        self.imageView.kf.setImage(with: urlSource)
    }
    
    @objc func tapPinButton(_ sender: UIButton) {
        guard let item else { return }
        contentManager.update(content: item) { item in
            item.isPinned.toggle()
        }
        
        delegate?.removePin(id: item.id)
    }
}
