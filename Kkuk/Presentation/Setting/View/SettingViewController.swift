//
//  SettingViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import SnapKit

import UIKit

class SettingViewController: BaseUIViewController {
    
    let settingItems = ["시스템 설정", "이용약관", "개인정보 정책", "서비스 이용방법"]
    let serviceInfoItems = ["고객 문의", "앱 버전"]
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.background
        view.separatorStyle = .none
        view.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        
        return view
    }()
    
    let clearDataButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.background
        view.addSubviews([tableView, clearDataButton])
        
        tableView.isScrollEnabled = false
        
        setNavigationBar()
        
        setUI()
        setLayout()
        setDelegate()
        setupClearDataButton()
    }
    
    override func setNavigationBar() {
    title = "설정"
    }
    
    func setupClearDataButton() {
        clearDataButton.setTitle("모든 데이터 지우기", for: .normal)
        clearDataButton.setTitleColor(.subgray1, for: .normal)

            // 밑줄 스타일을 적용하기 위해 NSAttributedString을 사용
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: UIFont.subtitle3
            ]
        
        let attributedString = NSAttributedString(string: "모든 데이터 지우기", attributes: attributes)
            clearDataButton.setAttributedTitle(attributedString, for: .normal)

            // 버튼의 액션을 추가
            clearDataButton.addTarget(self, action: #selector(clearData), for: .touchUpInside)
        
            view.addSubview(clearDataButton)
        }

        @objc func clearData() {
            // "모든 데이터 지우기" 버튼이 클릭되었을 때의 액션을 정의
            // ex, 사용자에게 경고 메시지를 표시하거나 데이터 삭제 작업을 시작
        }

    override func setUI() {
        view.addSubviews([tableView, clearDataButton])
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { constraint in
            constraint.leading.trailing.equalToSuperview().inset(20)
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            constraint.bottom.equalToSuperview()
            constraint.height.equalTo(tableView)
            tableView.rowHeight = 60
        }
        
        clearDataButton.snp.makeConstraints { make in
               make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-44)
               make.centerX.equalToSuperview()
               make.width.equalTo(200)
               make.height.equalTo(40)
           }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return settingItems.count
        case 1:
            return serviceInfoItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.background

        let label = UILabel()
        label.textColor = UIColor.main
        label.font = UIFont.title2
        label.text = section == 0 ? "서비스 정보" : "기타"
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingItemCell.identifier,
            for: indexPath
        ) as? SettingItemCell else {
            return .init()
        }
        
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            cell.configureCell(title: settingItems[indexPath.row])
        case 1:
            _ = serviceInfoItems[indexPath.row]
            if indexPath.row == 0 {
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "kkuk.us@gmail.com")
            } else if indexPath.row == 1 {
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "v1.0")
            } else {
                cell.configureCell(title: serviceInfoItems[indexPath.row])
            }
        default:
            break
        }

        return cell
    }
}
