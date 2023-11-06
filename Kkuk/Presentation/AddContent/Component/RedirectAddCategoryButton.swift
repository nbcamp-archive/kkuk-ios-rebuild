//
//  AddCategoryButton.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-11-03.
//

import UIKit

class RedirectAddCategoryButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        var configuration = UIButton.Configuration.plain()
        
        var attributeContainer = AttributeContainer()
        attributeContainer.font = .subtitle3
        
        configuration.baseForegroundColor = .main
        configuration.attributedTitle = AttributedString("추가하기", attributes: attributeContainer)
        configuration.image = Asset.redirectAddCategory
        configuration.imagePadding = CGFloat(4)
        configuration.imagePlacement = NSDirectionalRectEdge.leading
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 10, bottom: 4, trailing: 0)
        
        self.configuration = configuration
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
