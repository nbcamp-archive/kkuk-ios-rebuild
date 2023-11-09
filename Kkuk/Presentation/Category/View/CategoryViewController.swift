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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "lucide_folder_plus_white"), for: .normal)
        button.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var middleFrameView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        
        return view
    }()
    
    private lazy var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .background
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: "CategoryTableViewCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private var emptyCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리가 없습니다. \n 카테고리를 추가해주세요."
        label.textAlignment = .center
        label.font = .subtitle2
        label.textColor = .text1
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        category = categoryHelper.read()
        print("HI")
        if category.count == 0 {
            emptyCategoryLabel.isHidden = false
        } else {
            emptyCategoryLabel.isHidden = true
        }
        categoryTableView.reloadData()
    }
    
    override func setTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.trailing.leading.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.2)
        }
        
        topTitle.text = "카테고리"
        topView.addSubviews([topTitle, addButton])
        topTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            make.leading.equalTo(20)
        }
    }
    
    override func setNavigationBar() {}
    
    override func setUI() {
        view.addSubviews([middleFrameView])
        middleFrameView.addSubviews([categoryTableView, emptyCategoryLabel])
    }

    override func setLayout() {

        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(topTitle)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        middleFrameView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyCategoryLabel.snp.makeConstraints { make in
            make.center.equalTo(middleFrameView)
        }
        
        categoryTableView.snp.makeConstraints { constraint in
            constraint.top.bottom.equalTo(middleFrameView)
            constraint.leading.trailing.equalTo(middleFrameView).inset(20)
        }
    }

    override func setDelegate() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    override func addTarget() {}
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
        cell.accessoryView?.backgroundColor = .background
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
        emptyCategoryLabel.isHidden = true
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
