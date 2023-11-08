//
//  PanModalTableViewController.swift
//  Kkuk
//
//  Created by 장가겸 on 10/25/23.
//

import PanModal
import SnapKit
import UIKit

protocol PanModalTableViewControllerDelegate: AnyObject {
    func modifyTitle(title: String)
}

class PanModalTableViewController: BaseUIViewController {
    private var category: Category?
    
    private var modifyTitle: String?
    
    weak var delegate: PanModalTableViewControllerDelegate?
    
    private var panModalOption: PanModalOption?
    
    private var content: Content?
    
    private var helper = ContentHelper()
    
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
    
    init(option: PanModalOption, content: Content? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.panModalOption = option
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.modifyTitle(title: self.modifyTitle ?? self.category!.name)
    }
}

extension PanModalTableViewController {
    func setCategory(category: Category) {
        self.category = category
    }
}

extension PanModalTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = panModalOption?.title.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let title = panModalOption?.title[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PanModalTableViewCell",
                                                       for: indexPath) as? PanModalTableViewCell else { return UITableViewCell() }
        cell.configure(name: title.rawValue)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let count = panModalOption?.title.count else { return 0 }
        return (UIScreen.main.bounds.height * 0.25 ) / CGFloat(count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = panModalOption?.title[indexPath.row] else { return }
        switch panModalOption?.screenType {
        case .category: didSelectedCategoryScreen(menu)
        case .content: didSelectedContentScreen(menu)
        default: return
        }
    }
    
    func didSelectedCategoryScreen(_ menu: PanModalOption.Title) {
        switch menu {
        case .modify:
            let viewController = EditCategoryViewController()
            viewController.category = category
            viewController.delegate = self
            presentFromPanModal(to: viewController)
        case .delete:
            self.dismiss(animated: true)
            CategoryHelper.shared.delete(category!)
        case .cancel:
            self.dismiss(animated: true)
        default:
            return
        }
    }
    
    func didSelectedContentScreen(_ menu: PanModalOption.Title) {
        guard let content = content else { return }
        
        switch menu {
        case .modify:
            let viewController = AddContentViewController(isAddContent: false, modifyContent: content)
            presentFromPanModal(to: viewController)
        case .delete:
            showAlert(title: "삭제하시겠습니까?", message: nil, completion: {
                self.helper.delete(content)
                self.dismiss(animated: true)
            })
        case .share:
            guard let url = URL(string: content.sourceURL) else { return }
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true)
        case .cancel: dismiss(animated: true)
        }
    }
    
    func presentFromPanModal(to viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true)
    }
}

extension PanModalTableViewController: EditCategoryViewControllerDelegate {
    func setTitle(title: String) {
        modifyTitle = title
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
