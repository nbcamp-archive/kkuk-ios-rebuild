//
//  RecommendView.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/19.
//

import UIKit

final class RecommendView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .subgray2
        
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .subtitle2
        label.text = "성은 적을 방어하기 위한 거점으로 흙이나 돌 등을 높이 쌓아 만든 군사적 건축물을 알아보자"
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 12
        
        addSubviews([imageView, contentLabel])
        setLayout()
    }
    
    @available(*, unavailable) 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.top.equalToSuperview()
            constraint.height.equalTo(162)
        }
        
        contentLabel.snp.makeConstraints { constraint in
            constraint.bottom.horizontalEdges.equalToSuperview().inset(16)
            constraint.top.equalTo(imageView.snp.bottom).offset(16)
        }
    }
    
    func configureRecommend(content: String, image: UIImage?) {
        self.contentLabel.text = content
        self.imageView.image = image
    }
}
