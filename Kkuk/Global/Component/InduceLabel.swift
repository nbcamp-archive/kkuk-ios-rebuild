//
//  InduceLabel.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-27.
//

import UIKit

class InduceLabel: UILabel {
    
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        
        self.font = font
        self.text = text
        self.textColor = .text1
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
