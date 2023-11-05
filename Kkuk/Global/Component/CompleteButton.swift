//
//  CompleteButton.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-27.
//

import UIKit

class CompleteButton: UIButton {
    
    enum State {
        case disable
        case enable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI(to: .disable)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(to state: State) {
        var attributeContainer = AttributeContainer()
        
        var configuration = UIButton.Configuration.plain()
        
        attributeContainer.font = .subtitle2
        
        configuration.attributedTitle = AttributedString("완료", attributes: attributeContainer)
        configuration.baseForegroundColor = .white
        configuration.background.cornerRadius = CGFloat(8)
        
        switch state {
        case .disable:
            configuration.background.backgroundColor = .subgray3
            
            contentMode = .center
            isEnabled = false
        case .enable:
            configuration.background.backgroundColor = .main
            
            contentMode = .center
            isEnabled = true
        }
        
        self.configuration = configuration
    }
    
}
