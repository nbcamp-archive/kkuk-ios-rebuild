//
//  CustomGroupView.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/24.
//

import UIKit

class CustomGroupView: UIView {
    public var systemLabel: UILabel = {
        let label = UILabel()
        label.text = "시스템 설정"
        label.font = .title2
        label.textColor = .text1
        
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        
        return view
    }()
    
    private var clickButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        addSubviews([systemLabel, separatorView, clickButton])
        
        systemLabel.snp.makeConstraints { constraint in
           // constraint.top.equalTo(88)
            constraint.leading.equalTo(12)
        }
        
        separatorView.snp.makeConstraints { constraint in
            constraint.top.equalTo(systemLabel.snp.bottom).offset(10)
            constraint.leading.equalTo(12)
            constraint.trailing.equalTo(-12)
            constraint.height.equalTo(0.7)
        }
        
        clickButton.snp.makeConstraints { constraint in
            constraint.trailing.equalTo(-12)
            constraint.centerY.equalTo(systemLabel)
        }
    }

}
