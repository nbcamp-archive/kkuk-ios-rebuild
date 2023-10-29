//
//  CategoryInnerViewController.swift
//  Kkuk
//
//  Created by 장가겸 on 10/24/23.
//

import SnapKit
import UIKit

class CategoryInnerViewController: BaseUIViewController {
    private var contentManager = ContentManager()
    
    private var recentItems: [Content] = [] {
        didSet {
            noContentLabel.isHidden = !recentItems.isEmpty
        }
    }
    
    var category: Category?
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    private lazy var noContentLabel: UILabel = {
        let label = UILabel()
        label.text = "아카이브가 없습니다"
        label.font = .subtitle2
        label.textColor = .text1
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = !recentItems.isEmpty
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let contents = contentManager.readInCategory(at: category!.id).map { $0 as Content }
        recentItems = contents
        contentTableView.reloadData()
    }

    override func setUI() {
        view.addSubviews([contentTableView, noContentLabel])
    }
    
    override func setLayout() {
        contentTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        noContentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        contentTableView.delegate = self
        contentTableView.dataSource = self
    }
    
    @objc func categoryButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension CategoryInnerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell",
                                                       for: indexPath) as? ContentTableViewCell
        else { return UITableViewCell() }
        let item = recentItems[indexPath.row]
        
        cell.configureCell(title: item.title,
                           memo: item.memo,
                           image: item.imageURL,
                           url: item.sourceURL,
                           isPinned: false,
                           index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = recentItems[indexPath.row]
        
        let url = item.sourceURL
        let title = item.title
        
        let viewController = WebViewController(sourceURL: url, sourceTitle: title)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
