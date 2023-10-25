//
//  AppInfoViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

class AppInfoViewController: BaseUIViewController {
    let settingItems = ["시스템 설정"]
    let serviceInfoItems = ["이용약관", "개인정보 정책", "앱 버전", "고객 문의", "모든 데이터 지우기"]
    
    let tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        navigationController?.navigationBar.isHidden = false
        
        title = "설정"
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
    
    override func addTarget() {}
    
}

extension AppInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = section == 0 ? "설정" : "서비스 정보"
        
        let label = UILabel()
        label.textColor = .subgray1
        label.font = .subtitle2
        label.text = title
        
        return label
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingItemCell.identifier, for: indexPath) as? SettingItemCell else { return .init() }
        switch indexPath.section {
        case 0:
            cell.configureCell(title: settingItems[indexPath.row])
        case 1:
            if indexPath.row == 2 {
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "1.0")
            } else if indexPath.row == 3 {
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
