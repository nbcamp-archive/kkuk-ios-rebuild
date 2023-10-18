//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

class HomeViewController: BaseUIViewController {
    
    private var backgroundView: UIView = UIView().and {
        $0.backgroundColor = .main
    }
    
    private var homeLabel: UILabel = UILabel().and {
        $0.text = "이 콘텐츠는 어떠세요?"
        $0.font = .subtitle2
        $0.textColor = .background
    }
    
    private var recommendLabel: UILabel = UILabel().and {
        $0.text = "오늘의 추천"
        $0.font = .title1
        $0.textColor = .background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    override func setUI() {
        view.addSubview(backgroundView)
        view.addSubview(homeLabel)
        view.addSubview(recommendLabel)
    }
    
    override func setLayout() {
        
        backgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(450)
            $0.width.equalTo(view.safeAreaLayoutGuide)
        }
        
        homeLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalTo(20)
        }
        
        recommendLabel.snp.makeConstraints {
            $0.top.equalTo(homeLabel.snp.bottom).offset(8)
            $0.leading.equalTo(20)
        }
    }
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
}
