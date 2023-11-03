//
//  CategoryViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import SnapKit
import UIKit

class CategoryViewController: BaseUIViewController {
    private var category: [Category] = []
    private var categoryManager = RealmCategoryManager.shared

    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
    }()
    
    private var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitle("완료", for: .selected)

        button.setTitleColor(.text1, for: .normal)
        button.setTitleColor(.text1, for: [.normal, .highlighted])

        button.setTitleColor(.text1, for: .selected)
        button.setTitleColor(.text1, for: [.selected, .highlighted])

        return button
    }()
    
    private lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(customView: editButton)
        return button
    }()
    
    private lazy var addBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "addCategory"), style: .plain, target: self, action: #selector(plusButtonDidTap))
        button.tintColor = .text1
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = .title1
        label.textColor = .background
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
    }
    
    override func setNavigationBar() {
        title = "카테고리"
        navigationItem.rightBarButtonItems = [addBarButton, editBarButton]
    }
    
    override func setUI() {
        view.backgroundColor = .background
        view.addSubviews([categoryTableView, editButton])
        category = categoryManager.read()
    }

    override func setLayout() {
        categoryTableView.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.leading.trailing.equalToSuperview().inset(20)
            constraint.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    override func setDelegate() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    override func addTarget() {
        editButton.addTarget(self, action: #selector(editButtonDidTap), for: .touchUpInside)
    }
}

extension CategoryViewController {
    @objc func plusButtonDidTap() {
        let viewController = AddCategoryViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true)
    }
    
    @objc func editButtonDidTap() {
        let shouldBeEdited = !categoryTableView.isEditing
        categoryTableView.setEditing(shouldBeEdited, animated: true)
        editButton.isSelected = shouldBeEdited
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath)
            as? CategoryTableViewCell else { return UITableViewCell() }
        let category = category[indexPath.item]
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.configure(category: category)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customVC = CategoryInnerViewController()
        customVC.modalPresentationStyle = .fullScreen
        let category = category[indexPath.row]
        customVC.category = category
        navigationController?.pushViewController(customVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            categoryManager.delete(category[indexPath.row])
            category.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let targetItem: Category = category[sourceIndexPath.row]
        category.remove(at: sourceIndexPath.row)
        category.insert(targetItem, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView.isEditing {
            let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, _ in
                categoryManager.delete(category[indexPath.row])
                category.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let swipeAction = UISwipeActionsConfiguration(actions: [delete])
            swipeAction.performsFirstActionWithFullSwipe = false
            return swipeAction
        } else {
            let config = UISwipeActionsConfiguration()
            config.performsFirstActionWithFullSwipe = false
            return config
        }
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func reloadTableView() {
        category = categoryManager.read()
        categoryTableView.reloadData()
    }
}

extension CategoryViewController: CategoryTableViewCellDelegate {
    func deleteTableViewCell() {
        category = categoryManager.read()
        categoryTableView.reloadData()
    }
}
