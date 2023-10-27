//
//  WebViewToolbar.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-25.
//

import UIKit

class WebViewToolbar: UIToolbar {
    
    lazy var backwardButton = UIBarButtonItem(image: Asset.backward.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var forwardButton = UIBarButtonItem(image: Asset.forward.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var shareButton = UIBarButtonItem(image: Asset.share.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var safariButton = UIBarButtonItem(image: Asset.safari.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
    
    lazy var flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    lazy var barButtonItems = [backwardButton, flexibleSpace, forwardButton, flexibleSpace, shareButton, flexibleSpace, safariButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isTranslucent = false
        barTintColor = .background
        
        barButtonItems.forEach {
            $0.tintColor = .selected
        }
        
        setItems(barButtonItems, animated: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
