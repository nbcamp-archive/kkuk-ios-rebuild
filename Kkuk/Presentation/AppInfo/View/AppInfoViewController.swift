//
//  AppInfoViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

class AppInfoViewController: BaseUIViewController {
    
    private var settingSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
        label.font = .title3
        label.textColor = .subgray1
        return label
    }()
    
    private var systemGroupView: CustomGroupView = {
        let view = CustomGroupView()
        view.systemLabel.text = "시스템 설정"
        return view
    }()
    
    private var serviceInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "서비스 정보"
        label.font = .title3
        label.textColor = .subgray1
        return label
    }()
    
    private var termsGroupView: CustomGroupView = {
        let view = CustomGroupView()
        view.systemLabel.text = "이용약관"
        return view
    }()
    
    private var policyGroupView: CustomGroupView = {
        let view = CustomGroupView()
        view.systemLabel.text = "개인정보 정책"
        return view
    }()
    
    private var versionLabel: UILabel = {
        let label = UILabel()
        label.text = "앱 버전"
        label.font = .title2
        label.textColor = .text1
        return label
    }()
    
    private var versionInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "1.0"
        label.font = .subtitle1
        label.textColor = .text1
        return label
    }()
    
    private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    private var questionLabel: UILabel = {
        let label = UILabel()
        label.text = "고객문의"
        label.font = .title2
        label.textColor = .text1
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "kkuk.us@gmail.com"
        label.font = .subtitle1
        label.textColor = .text1
        return label
    }()
    
    private var deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "모든 데이터 지우기"
        label.font = .subtitle1
        label.textColor = .text1
        return label
    }()
    
    private var separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
    }
    
    override func setUI() {
        view.addSubviews([settingSectionLabel, systemGroupView, serviceInfoLabel, termsGroupView, policyGroupView])
        view.addSubviews([versionLabel, versionInfoLabel, separatorView, questionLabel, emailLabel, deleteLabel, separateView])
    }
    
    override func setLayout() {
        settingSectionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            constraint.leading.equalTo(22)
        }
        
        systemGroupView.snp.makeConstraints { constraint in
            constraint.top.equalTo(settingSectionLabel.snp.bottom).offset(20)
            constraint.leading.trailing.equalToSuperview().inset(12)
        }
        
        serviceInfoLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(142)
            constraint.leading.equalTo(22)
        }
        
        termsGroupView.snp.makeConstraints { constraint in
            constraint.top.equalTo(serviceInfoLabel.snp.bottom).offset(20)
            constraint.leading.trailing.equalToSuperview().inset(12)
        }
        
        policyGroupView.snp.makeConstraints { constraint in
            constraint.top.equalTo(termsGroupView.snp.bottom).offset(48)
            constraint.leading.trailing.equalToSuperview().inset(12)
        }
        
        versionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(policyGroupView.snp.bottom).offset(48)
            constraint.leading.equalTo(25)
        }
        
        versionInfoLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(policyGroupView.snp.bottom).offset(48)
            constraint.trailing.equalTo(-25)
        }
        
        separatorView.snp.makeConstraints { constraint in
            constraint.top.equalTo(versionInfoLabel.snp.bottom).offset(10)
            constraint.leading.equalTo(25)
            constraint.trailing.equalTo(-25)
            constraint.height.equalTo(0.7)
        }
        
        questionLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(separatorView.snp.bottom).offset(12)
            constraint.leading.equalTo(25)
        }
        
        emailLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(separatorView.snp.bottom).offset(12)
            constraint.trailing.equalTo(-25)
        }
        
        deleteLabel.snp.makeConstraints { constraint in
            constraint.centerX.equalToSuperview()
            constraint.top.equalTo(emailLabel.snp.bottom).offset(80)
        }
        
        separateView.snp.makeConstraints { constraint in
            constraint.top.equalTo(deleteLabel.snp.bottom).offset(10)
            constraint.leading.equalTo(25)
            constraint.trailing.equalTo(-25)
            constraint.height.equalTo(0.7)
        }
    }
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
}
