//
//  CategoryViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import SnapKit
import UIKit

class CategoryViewController: BaseUIViewController {
    private var category = [Category]()
    
    private var categoryHelper = CategoryHelper.shared

    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    private lazy var addCategoryButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Asset.addCategory.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        return buttonItem
    }()

    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        return tableView
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        category = categoryHelper.read()
        categoryTableView.reloadData()
    }
    
    override func setNavigationBar() {
        title = "카테고리"
        
        navigationController?.navigationBar.backgroundColor = .main
        
        navigationItem.rightBarButtonItem = addCategoryButtonItem
    }
    
    override func setUI() {
        view.addSubview(categoryTableView)
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
        addCategoryButtonItem.target = self
        addCategoryButtonItem.action = #selector(plusButtonDidTap)
    }
}

// MARK: - @objc

extension CategoryViewController {
    @objc func plusButtonDidTap() {
        let viewController = AddCategoryViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .overFullScreen
        present(navigationController, animated: true, completion: nil)
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
        customVC.setCategory(category: category[indexPath.row])
        navigationController?.pushViewController(customVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension CategoryViewController: AddCategoryViewControllerDelegate {
    func reloadTableView() {
        category = categoryHelper.read()
        categoryTableView.reloadData()
    }
}

extension CategoryViewController: CategoryTableViewCellDelegate {
    func deleteTableViewCell() {
        category = categoryHelper.read()
        categoryTableView.reloadData()
    }
}
