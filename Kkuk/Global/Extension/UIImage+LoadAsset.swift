//
//  UIImage+LoadAsset.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import UIKit

extension UIImage {
    
    static func loadAsset(named name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
}
