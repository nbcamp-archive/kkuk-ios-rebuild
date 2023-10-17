//
//  UIFont+FontSizes.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-17.
//

import UIKit

extension UIFont {
    
    class var largeTitle: UIFont {
        guard let font = UIFont(name: "Pretendard-Bold", size: CGFloat(28)) else {
            return UIFont.boldSystemFont(ofSize: CGFloat(28))
        }
        return font
    }
    
    class var title1: UIFont {
        guard let font = UIFont(name: "Pretendard-Bold", size: CGFloat(24)) else {
            return UIFont.boldSystemFont(ofSize: CGFloat(28))
        }
        return font
    }
    
    class var title2: UIFont {
        guard let font = UIFont(name: "Pretendard-SemiBold", size: CGFloat(20)) else {
            return UIFont.systemFont(ofSize: CGFloat(20))
        }
        return font
    }
    
    class var title3: UIFont {
        guard let font = UIFont(name: "Pretendard-SemiBold", size: CGFloat(18)) else {
            return UIFont.systemFont(ofSize: CGFloat(18))
        }
        return font
    }
    
    class var subtitle1: UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: CGFloat(18)) else {
            return UIFont.systemFont(ofSize: CGFloat(18))
        }
        return font
    }
    
    class var subtitle2: UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: CGFloat(16)) else {
            return UIFont.systemFont(ofSize: CGFloat(16))
        }
        return font
    }
    
    class var subtitle3: UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: CGFloat(14)) else {
            return UIFont.systemFont(ofSize: CGFloat(14))
        }
        return font
    }
    
    class var subtitle4: UIFont {
        guard let font = UIFont(name: "Pretendard-Medium", size: CGFloat(12)) else {
            return UIFont.systemFont(ofSize: CGFloat(12))
        }
        return font
    }
    
    class var body1: UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: CGFloat(16)) else {
            return UIFont.systemFont(ofSize: CGFloat(14))
        }
        return font
    }
    
    class var body2: UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: CGFloat(14)) else {
            return UIFont.systemFont(ofSize: CGFloat(14))
        }
        return font
    }
    
    class var body3: UIFont {
        guard let font = UIFont(name: "Pretendard-Regular", size: CGFloat(12)) else {
            return UIFont.systemFont(ofSize: CGFloat(12))
        }
        return font
    }
    
}
