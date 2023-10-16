//
//  UIStackView+AddArrangedSubviews.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
    
}
