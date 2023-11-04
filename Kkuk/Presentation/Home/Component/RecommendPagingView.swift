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
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 50

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
        self.addSubviews([emptyStateView, scrollView, pageControl])
        self.scrollView.addSubview(itemStackView)
        self.scrollView.delegate = self
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        emptyStateView.snp.makeConstraints { constraint in
            constraint.top.leading.trailing.equalToSuperview()
            constraint.bottom.equalTo(pageControl.snp.top).offset(-8)
        }
        
        self.scrollView.snp.makeConstraints { constraint in
            constraint.leading.trailing.top.equalToSuperview()
            constraint.bottom.equalTo(pageControl.snp.top).offset(-8)
            constraint.height.equalTo(itemStackView)
        }
        
        self.itemStackView.snp.makeConstraints { constraint in
            constraint.bottom.top.equalToSuperview()
            constraint.horizontalEdges.equalToSuperview().inset(25)
        }
        
        pageControl.setContentHuggingPriority(.required, for: .vertical)
        pageControl.setContentCompressionResistancePriority(.required, for: .vertical)
        self.pageControl.snp.makeConstraints { constraint in
            constraint.centerX.equalToSuperview()
            constraint.bottom.equalToSuperview().offset(-8)
        }
    }
        
    func setItems(items: [Content]) {
        resetItem()
        if items.isEmpty {
            emptyStateView.isHidden = false
            pageControl.numberOfPages = 0
            return
        }
        
        self.items = items
        self.pageControl.numberOfPages = items.count
        let width = UIScreen.main.bounds.width - 50
        
        for index in 0..<items.count {
            
            let view = RecommendView()
            view.configureRecommend(content: items[index])
            
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
