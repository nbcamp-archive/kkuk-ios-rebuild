//
//  PanModalTableViewController.swift
//  Kkuk
//
//  Created by 장가겸 on 10/25/23.
//

import PanModal
import SnapKit
import UIKit

enum PanModalOption: String {
    case modify = "수정"
    case delete = "삭제"
    case cancel = "취소"
}

class PanModalTableViewController: BaseUIViewController {
    var category: Category?
    
    private lazy var deleteModifyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PanModalTableViewCell.self, forCellReuseIdentifier: "PanModalTableViewCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.estimatedRowHeight = 34
        return tableView
    }()
    
    private let modalOption = [PanModalOption.modify, PanModalOption.delete, PanModalOption.cancel]

    override func setUI() {
        view.addSubview(deleteModifyTableView)
    }

    /// 화면 레이아웃을 설정하기 위한 사용자 정의 함수입니다.
    override func setLayout() {
        deleteModifyTableView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }

    /// 델리게이트 설정을 위한 사용자 정의 함수입니다.
    override func setDelegate() {
        deleteModifyTableView.delegate = self
        deleteModifyTableView.dataSource = self
        deleteModifyTableView.allowsSelection = true
    }
}

extension PanModalTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        modalOption.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PanModalTableViewCell",
                                                       for: indexPath) as? PanModalTableViewCell else { return UITableViewCell() }
        cell.configure(name: modalOption[indexPath.row].rawValue)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height * 0.25 ) / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let viewController = EditCategoryViewController()
            viewController.category = category
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            navigationController.modalTransitionStyle = .coverVertical
            present(navigationController, animated: true)
        case 1:
            self.dismiss(animated: true)
            RealmCategoryManager.shared.delete(category!)
        case 2:
            self.dismiss(animated: true)
        default:
            return
        }
    }
}

 extension PanModalTableViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        deleteModifyTableView
    }

    var shortFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 0.25)
    }
     
     var longFormHeight: PanModalHeight {
         .contentHeight(UIScreen.main.bounds.height * 0.25)
     }

    var allowsTapToDismiss: Bool {
        true
    }

    var dragIndicatorBackgroundColor: UIColor {
         .clear
     }
 }
