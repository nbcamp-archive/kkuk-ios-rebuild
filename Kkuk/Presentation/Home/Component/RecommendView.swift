//
//  RecommendView.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/19.
//

import UIKit

protocol RecommendViewDelegate: AnyObject {
    func selectedPin()
}

final class RecommendView: UIView {
    private var item: Content?
    
    weak var delegate: RecommendViewDelegate?
    
    private var contentManager = ContentManager()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .subgray3
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.subgray2.cgColor
        view.layer.borderWidth = 0.7
        
        return view
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .subtitle2
        label.text = "성은 적을 방어하기 위한 거점으로 흙이나 돌 등을 높이 쌓아 만든 군사적 건축물을 알아보자"
        
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.subgray2.cgColor
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
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.top.equalToSuperview()
            constraint.height.equalTo(150)
        }
        
        contentLabel.snp.makeConstraints { constraint in
            constraint.bottom.horizontalEdges.equalToSuperview().inset(14)
            constraint.top.equalTo(imageView.snp.bottom).offset(14)
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
    
    func configureRecommend(content: Content) {
        self.item = content
        self.contentLabel.text = content.title
        let url = content.imageURL
        DispatchQueue.global().async {
            guard let url = URL(string: url ?? ""),
                  let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func tapPinButton(_ sender: UIButton) {
        guard let item else { return }
        contentManager.update(content: item) { item in
            item.isPinned.toggle()
        }
        
        delegate?.selectedPin()
    }

}

extension CALayer {
    func addBottomBorder(with color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = UIColor.subgray3.cgColor
        border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.width, height: width)
        addSublayer(border)
    }
}
