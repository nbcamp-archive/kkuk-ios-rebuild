//
//  RecommendPagingView.swift
//  Kkuk
//
//  Created by se-ryeong on 2023/10/19.
//

import UIKit

final class RecommendPagingView: UIView {
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    let itemStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 40

        return view
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.numberOfPages = 3
        control.currentPage = 0
        control.pageIndicatorTintColor = .subgray2
        control.currentPageIndicatorTintColor = .white
        
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.scrollView)
        self.addSubview(self.pageControl)
        
        self.scrollView.addSubview(itemStackView)
        
        self.scrollView.delegate = self
        
        self.scrollView.snp.makeConstraints { constraint in
            constraint.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.itemStackView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview()
            constraint.horizontalEdges.equalToSuperview().inset(20)
        }
        
        self.pageControl.snp.makeConstraints { constraint in
            constraint.top.equalTo(itemStackView.snp.bottom).offset(12)
            constraint.centerX.equalToSuperview()
            constraint.bottom.equalTo(scrollView.snp.bottom).offset(-12)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setItems(items: [String]) {
        
        self.pageControl.numberOfPages = items.count
        let width = UIScreen.main.bounds.width-40
        
        for index in 0..<items.count {
            let view = RecommendView()
            view.configureRecommend(content: items[index], image: nil)
            
            self.scrollView.contentSize.width = width * CGFloat(index+2)
            
            itemStackView.addArrangedSubview(view)
            
            view.snp.makeConstraints { constraint in
                constraint.width.equalTo(width)
            }
        }
    }
    
    func resetItem() {
        self.scrollView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
}

extension RecommendPagingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // scrollView가 스와이프 될 때 발생 될 이벤트
        self.pageControl.currentPage = Int(round(scrollView.contentOffset.x / (UIScreen.main.bounds.width)))
    }
}
