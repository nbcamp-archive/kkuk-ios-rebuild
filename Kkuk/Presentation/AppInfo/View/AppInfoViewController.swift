//
//  AppInfoViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit
import SnapKit

class AppInfoViewController: BaseUIViewController {
    
    let settingItems = ["이용약관", "개인정보 정책", "시스템 설정", "서비스 이용방법"]
    let serviceInfoItems = ["앱 버전", "고객 문의", "모든 데이터 지우기"]
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.background
        
        setNavigationBar()
        setCustomTitleView()
        
        setUI()
        setLayout()
        setDelegate()
    }
    
    func setCustomTitleView() {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.orange
        titleLabel.font = UIFont.title2
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
            navigationItem.leftBarButtonItem = leftItem
        }
    
    override func setUI() {
        view.addSubviews([tableView])
    }
    
    override func setLayout() {
        tableView.snp.makeConstraints { constraint in
            constraint.leading.trailing.equalToSuperview().inset(20)
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.bottom.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension AppInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        label.textColor = UIColor.orange
        label.font = UIFont.title2
        label.text = section == 0 ? "About KKuk" : "Support"
        
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
        switch indexPath.section {
        case 0:
            cell.configureCell(title: settingItems[indexPath.row])
        case 1:
            let title = serviceInfoItems[indexPath.row]
            if indexPath.row == 0 {
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "v1.0")
            } else if indexPath.row == 1 {
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "kkuk.us@gmail.com")
            } else {
                cell.configureCell(title: serviceInfoItems[indexPath.row])
            }
        default:
            break
        }

        return cell
    }
}
