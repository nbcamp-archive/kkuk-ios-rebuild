//
//  SettingViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import SnapKit
import UIKit
import RealmSwift

class SettingViewController: BaseUIViewController {
    
    let settingItems = ["시스템 설정", "이용약관", "서비스 이용방법"]
    let serviceInfoItems = ["고객 문의", "앱 버전"]
    
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = UIColor.background
        view.separatorStyle = .none
        view.register(SettingItemCell.self, forCellReuseIdentifier: SettingItemCell.identifier)
        view.rowHeight = CGFloat(52)
        return view
    }()
    
    let clearDataButton = UIButton(type: .system)
    
    override func setTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
        
        topTitle.text = "설정"
        topView.addSubviews([topTitle])
        topTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.equalTo(20)
        }
    }
    
    override func setNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .clear
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.background
        
        setNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        setupClearDataButton()
    }
    
    override func setUI() {
        view.addSubviews([tableView, clearDataButton])
        tableView.isScrollEnabled = false
    }

    override func setLayout() {
        // tableView 제약 조건을 설정
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.bottom.equalTo(clearDataButton.snp.top).offset(-20)
        }
        
        // clearDataButton 제약 조건을 설정
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
    
        func setupClearDataButton() {
            clearDataButton.setTitle("모든 데이터 지우기", for: .normal)
            clearDataButton.setTitleColor(.subgray1, for: .normal)
            clearDataButton.addTarget(self, action: #selector(clearData), for: .touchUpInside)
            
                // 밑줄 스타일을 적용하기 위해 NSAttributedString을 사용
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue,
                .font: UIFont.subtitle3
                ]
            
            let attributedString = NSAttributedString(string: "모든 데이터 지우기", attributes: attributes)
                clearDataButton.setAttributedTitle(attributedString, for: .normal)
            
                view.addSubview(clearDataButton)
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
        label.textColor = UIColor.systemGray
        label.font = UIFont.title2
        label.text = section == 0 ? "서비스 정보" : "기타"
        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(0)
            make.centerY.equalToSuperview()
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
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
                cell.configureCell(title: serviceInfoItems[indexPath.row], subTitle: "kkuk.help@gmail.com")
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
    
    @objc func clearData() {
        // UIAlertController를 생성. style을 .alert로 지정하여 팝업 형태로 표시
        let alertController = UIAlertController(title: "", message: "모든 데이터를 지우겠습니까?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "네", style: .destructive) { [weak self] _ in
            do {
                // 여기에 데이터를 지우는 코드를 추가
                let realm = try Realm()
                try realm.write {
                    realm.deleteAll()
                }
                
                let uncategorized = Category()
                let categoryHelper = CategoryHelper.shared
                uncategorized.name = "미분류"
                uncategorized.iconId = 1
                categoryHelper.write(uncategorized)
                
                self?.showAlertWith(title: "완료", message: "모든 데이터가 삭제되었습니다.")
            } catch {
                self?.showAlertWith(title: "오류", message: "데이터를 삭제하는데 실패했습니다: \(error.localizedDescription)")
            }
        }
        
        // "아니오"를 탭했을 때 실 alert을 닫음
        let cancelAction = UIAlertAction(title: "아니오", style: .cancel, handler: nil)
        
        // 생성한 액션들을 UIAlertController에 추가
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
extension SettingViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 첫 번째 섹션의 "시스템 설정" 셀이 선택되었는지 확인
        if indexPath.section == 0 && indexPath.row == 0 {
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
        let item = settingItems[indexPath.row]

        if indexPath.row == 1 {
            if let urlString = URL(string: "https://mammoth-scabiosa-20c.notion.site/8b2d6db3412c46578505d588f8a4d22a?pvs=4")?.absoluteString {
                let viewController = WebViewController(sourceURL: urlString, sourceTitle: "이용약관")
                viewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(viewController, animated: true)
            }
        } else if indexPath.row == 2 {
            if let urlString = URL(string: "https://mammoth-scabiosa-20c.notion.site/c0d1bd0595d84f9fbaa2b05dd0cd70f1?pvs=4")?.absoluteString {
                let viewController = WebViewController(sourceURL: urlString, sourceTitle: "서비스 이용방법")
                viewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
}
