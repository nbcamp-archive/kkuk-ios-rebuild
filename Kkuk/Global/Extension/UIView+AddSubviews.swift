//
//  UIView+AddSubviews.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
}
