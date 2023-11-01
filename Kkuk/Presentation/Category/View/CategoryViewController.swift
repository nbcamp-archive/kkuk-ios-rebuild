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
        tableView.register(CategoryCollectionViewCell.self, forCellReuseIdentifier: "CategoryCollectionViewCell")
        return tableView
    }()
    
    private var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.setTitle("완료", for: .selected)
        
        button.setTitleColor(.background, for: .normal)
        button.setTitleColor(.background, for: [.normal, .highlighted])
        
        button.setTitleColor(.background, for: .selected)
        button.setTitleColor(.background, for: [.selected, .highlighted])
        
        return button
    }()
    
    private var topFrameView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .main
        
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = .title1
        label.textColor = .background
        return label
    }()
    
    private var plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .main
        button.layer.cornerRadius = 30
        button.setImage(UIImage(named: "Plus"), for: .normal)
        button.tintColor = .background
        
        return button
    }()
    
    override func setNavigationBar() {
        title = "카테고리"
    }
    
    override func setUI() {
        view.backgroundColor = .background
        view.addSubviews([topFrameView, categoryTableView, plusButton, editButton])
        topFrameView.addSubviews([titleLabel])
        category = categoryManager.read()
    }

    override func setLayout() {
        topFrameView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            constraint.leading.equalTo(20)
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel)
            make.right.equalToSuperview().inset(20)
        }
        
        categoryTableView.snp.makeConstraints { constraint in
            constraint.top.equalTo(titleLabel.snp.bottom).offset(20)
            constraint.leading.trailing.equalToSuperview()
            constraint.bottom.equalTo(topFrameView.snp.bottom)
        }
        
        plusButton.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-32)
            constraint.trailing.equalTo(-20)
            constraint.height.width.equalTo(60)
        }
    }

    override func setDelegate() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    override func addTarget() {
        plusButton.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCollectionViewCell", for: indexPath)
            as? CategoryCollectionViewCell else { return UITableViewCell() }
        let category = category[indexPath.item]
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
            swipeAction.performsFirstActionWithFullSwipe = false // This is the line which disables full swipe
            return swipeAction
        } else {
            let config = UISwipeActionsConfiguration()
            config.performsFirstActionWithFullSwipe = false
            return config
        }
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func reloadCollectionView() {
        category = categoryManager.read()
        categoryTableView.reloadData()
    }
}

extension CategoryViewController: CategoryCollectionViewCellDelegate {
    func deleteCollectionViewCell() {
        category = categoryManager.read()
        categoryTableView.reloadData()
    }
}
