//
//  UIImage+LoadAsset.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-24.
//

import UIKit

// !!!: Command SwiftCompile failed with a nonzero exit code
// CategoryHelper.swift 참고
// UIImage는 non-sendable한 객체지만 @unchecked Sendable 시도는 Swift 6에선 허용되지 않음
extension UIImage {
    @MainActor
    static func loadAsset(named name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
}
