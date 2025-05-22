//
//  Toast.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-28.
//

import UIKit

@MainActor
class Toast {

    static func showToast(_ viewController: UIViewController, message: String) {
        let xPosition = viewController.view.frame.size.width
        let yPosition = viewController.view.safeAreaInsets.top

        let frame = CGRect(x: xPosition / 2 - 75, y: yPosition, width: 179, height: 44)

        let toastLabel = UILabel(frame: frame)
        toastLabel.backgroundColor = .black.withAlphaComponent(0.6)
        toastLabel.alpha = CGFloat(1)
        toastLabel.font = .subtitle3
        toastLabel.layer.cornerRadius = CGFloat(16)
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.clipsToBounds = true

        viewController.view.addSubview(toastLabel)

        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 1.0
            toastLabel.frame.origin.y += 50
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
                toastLabel.alpha = 0.0
                toastLabel.frame.origin.y -= 50
            }, completion: { _ in
                toastLabel.removeFromSuperview()
            })
        })
    }

}
