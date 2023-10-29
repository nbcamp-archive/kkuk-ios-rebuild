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
    
    private var emptyStateView = EmptyStateView()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.pageIndicatorTintColor = .subgray2
        control.currentPageIndicatorTintColor = .white
        
        return control
    }()
    
    private var items: [Content] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubviews([scrollView, pageControl, emptyStateView])
        self.scrollView.addSubview(itemStackView)
        self.scrollView.delegate = self
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
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
        
        emptyStateView.snp.makeConstraints { constraint in
            constraint.centerX.equalToSuperview()
            constraint.top.equalToSuperview()
            constraint.bottom.equalToSuperview().offset(-28)
        }
    }
        
    func setItems(items: [Content]) {
        resetItem()
        if items.isEmpty {
            emptyStateView.isHidden = false
            pageControl.isHidden = true
            return
        }
        
        self.items = items
        self.pageControl.numberOfPages = items.count
        let width = UIScreen.main.bounds.width-40
        
        for index in 0..<items.count {
            let view = RecommendView()
            view.configureRecommend(content: items[index])
            
            self.scrollView.contentSize.width = width * CGFloat(index+2)
            
            itemStackView.addArrangedSubview(view)
            
            view.snp.makeConstraints { constraint in
                constraint.width.equalTo(width)
            }
        }
    }
    
    private func resetItem() {
        pageControl.isHidden = false
        emptyStateView.isHidden = true
        
        itemStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
}

extension RecommendPagingView: UIScrollViewDelegate {
    // scrollView가 스와이프 될 때 발생 될 이벤트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.currentPage = Int(round(scrollView.contentOffset.x / (UIScreen.main.bounds.width)))
    }
}
