//
//  AddContentButton.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-19.
//

import UIKit

class AddContentButton: UIButton {
    
    enum ButtonStateType {
        case normal, enable, disable
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI(for: .normal)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI(for state: ButtonStateType) {
        switch state {
        case .normal:
            contentMode = .center
            backgroundColor = .subgray2
            isEnabled = false
            setTitle("완료", for: .normal)
            setTitleColor(.white, for: .normal)
        case .enable:
            contentMode = .center
            backgroundColor = .main
            isEnabled = true
            setTitle("완료", for: .normal)
            setTitleColor(.white, for: .normal)
        case .disable:
            contentMode = .center
            backgroundColor = .subgray2
            isEnabled = false
            setTitle("완료", for: .normal)
            setTitleColor(.white, for: .normal)
        }
    }
    
    func updateButtonState(with text: String?) {
        guard let url = text, !url.isEmpty else {
            setUI(for: .disable)
            return
        }
        
        if isValidURL(with: url) {
            setUI(for: .enable)
        } else if !url.isEmpty {
            setUI(for: .enable)
        } else {
            setUI(for: .normal)
        }
    }
    
    func isValidURL(with url: String) -> Bool {
        if let url = NSURL(string: url) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
}
