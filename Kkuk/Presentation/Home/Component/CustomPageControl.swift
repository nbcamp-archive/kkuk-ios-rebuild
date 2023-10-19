//
//  CustomPageControl.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/18.
//

import UIKit

class CustomPageControl: UIPageControl {
    var indicatorImage: UIImage?
    var currentIndicatorImage: UIImage?
    
    override var currentPage: Int {
        didSet {
            updateDot()
        }
    }
    
    private func updateDot() {
    }
    
    private func imageViewForSubview(view: UIView) -> UIImageView {
        var dot: UIImageView!
        
        if let imgView = view as? UIImageView {
            dot = imgView
        } else {
            for subview: UIView in view.subviews {
                if let subimgView = subview as? UIImageView {
                    dot = subimgView
                }
            }
            
            if dot == nil {
                dot = UIImageView(frame: .zero)
                view.addSubview(dot!)
            }
        }
        
        dot?.contentMode = .scaleAspectFit
        return dot!
    }
}
