//
//  AddCategoryView.swift
//  Kkuk
//
//  Created by 손영하  on 2023/10/24.
//

import UIKit

class CategoryTitleInputLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "카테고리 이름"
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CategoryInputTextField: UITextField {
    
    private var clearButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        placeholder = "카테고리 이름을 입력하세요"
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        textAlignment = .left
        font = UIFont.systemFont(ofSize: 16)
        textColor = .black
        autocorrectionType = .no
        layer.cornerRadius = 5
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.frame.height))
        leftView = paddingView
        leftViewMode = .always
        clearButton = UIButton(type: .custom)
                clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = UIColor.orange
                clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
                clearButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                
                rightView = clearButton
                rightViewMode = .whileEditing
    }
    
    @objc private func clearTextField() {
            self.text = ""
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CategoryInputLimitLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        text = "0/20"
        font = UIFont.systemFont(ofSize: 12)
        textColor = .gray
        textAlignment = .right
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IconSelectButton: UIButton {
    override var isSelected: Bool {
        didSet {
            self.imageView?.tintColor = isSelected ? UIColor.darkGray : UIColor.clear
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class ConfirmButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle("확인", for: .normal)
        backgroundColor = .orange
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 4
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
