//
//  CompleteButton.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-27.
//

import UIKit

protocol CompleteButtonDelegate: AnyObject {
    func updateState()
}

// let completeButton = CompleteButton(title: "", type: .content or .category)
class CompleteButton: UIButton {
    
    weak var delegate: CompleteButtonDelegate?
    
    enum ButtonState {
        case disable, enable
    }
    
    init(frame: CGRect, state: ButtonState) {
        super.init(frame: frame)
        
        configure(state: state)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(state: ButtonState) {
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .subtitle3

        var configuration = UIButton.Configuration.plain()
        configuration.attributedTitle = AttributedString("완료", attributes: attributeContainer)
        configuration.background.cornerRadius = CGFloat(0)
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = .main
    }
    
}
