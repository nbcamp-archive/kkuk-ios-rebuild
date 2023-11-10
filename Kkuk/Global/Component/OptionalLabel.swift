//
//  OptionalLabel.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-31.
//

import UIKit

class OptionalLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.adjustsFontSizeToFitWidth = true
        self.font = .body2
        self.textColor = .subgray1
        self.text = "선택사항"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
