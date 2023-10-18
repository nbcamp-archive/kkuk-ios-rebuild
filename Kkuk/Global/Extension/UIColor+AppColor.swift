//
//  UIColor+AppColor.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/18.
//

import UIKit

extension UIColor {
    
    static var main: UIColor {
        guard let color = UIColor(named: "main") else {
            return UIColor.orange
        }
        return color
    }

    static var text1: UIColor {
        guard let color = UIColor(named: "text1") else {
            return UIColor.black
        }
        return color
    }

    static var subgray1: UIColor {
        guard let color = UIColor(named: "subgray1") else {
            return UIColor.systemGray
        }
        return color
    }

    static var subgray2: UIColor {
        guard let color = UIColor(named: "subgray2") else {
            return UIColor.systemGray2
        }
        return color
    }

    static var subgray3: UIColor {
        guard let color = UIColor(named: "subgray3") else {
            return UIColor.systemGray3
        }
        return color
    }

    static var background: UIColor {
        guard let color = UIColor(named: "background") else {
            return UIColor.white
        }
        return color
    }
    
}
