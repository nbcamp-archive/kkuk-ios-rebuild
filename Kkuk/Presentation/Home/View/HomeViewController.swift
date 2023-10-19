//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

class HomeViewController: BaseUIViewController, UIScrollViewDelegate {
    
    private var topFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        
        return view
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이 콘텐츠는 어떠세요?"
        label.font = .subtitle2
        label.textColor = .background
        
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 추천"
        label.font = .title1
        label.textColor = .background
        
        return label
    }()
    
    private let recommendPagingView = RecommendPagingView()
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        recommendPagingView.setItems(items: ["111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111", "222222222222", "333333333333"])
    }
    
    override func setUI() {
        view.addSubview(topFrameView)
        view.addSubview(subTitleLabel)
        view.addSubview(titleLabel)
        view.addSubview(recommendPagingView)
        
    }
    
    override func setLayout() {
        topFrameView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview()
            constraint.height.equalTo(450)
            constraint.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        subTitleLabel.snp.makeConstraints{ constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            constraint.leading.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            constraint.leading.equalTo(20)
        }
        
        recommendPagingView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.equalToSuperview()
            constraint.top.equalTo(titleLabel.snp.bottom).offset(28)
            constraint.height.equalTo(236)
        }
    }
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
}
