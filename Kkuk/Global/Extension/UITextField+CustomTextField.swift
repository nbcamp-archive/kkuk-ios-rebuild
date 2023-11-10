//
//  File.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/11/09.
//

import UIKit

extension UITextField {
    func configureCommonStyle() {
        self.font = .body1
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.clearButtonMode = .whileEditing
        
        self.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 8.0, height: 0.0))
        self.leftViewMode = .always
        
        self.backgroundColor = .subgray3
        self.layer.borderWidth = 0
        self.layer.borderColor = nil
    }
    
    func configureForEditing() {
        self.backgroundColor = .background
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.main.cgColor
    }
}
