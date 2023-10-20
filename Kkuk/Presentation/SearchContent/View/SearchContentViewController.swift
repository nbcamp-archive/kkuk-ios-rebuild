//
//  SearchContentViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class SearchContentViewController: BaseUIViewController {
    
    let contentList: [String] = []
    
    let recentSearchContentViewController = RecentSearchContentViewController()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .clear
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.black.cgColor
            textField.layer.cornerRadius = 12.0
          }
        
        return searchBar
    }()
    
    private lazy var contentTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
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
        label.isHidden = !contentList.isEmpty
        return label
    }()

    override func setUI() {
        view.addSubviews([searchBar, contentTableView, noContentLabel])
    }
    
    override func setLayout() {
        setSearchBarLayout()
        setContentTableViewLayout()
        setNoContentLabelLayout()
    }
    
    override func setDelegate() {}
    
    override func addTarget() {}
    
    func setSearchBarLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setContentTableViewLayout() {
        contentTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(48)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setNoContentLabelLayout() {
        noContentLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }
    }
}

extension SearchContentViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: false)
        
        let containerView = UIView()
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        addChild(recentSearchContentViewController)
        containerView.addSubview(recentSearchContentViewController.view)
        
        recentSearchContentViewController.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView.snp.edges)
        }
        
        recentSearchContentViewController.didMove(toParent: self)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleCancelButtonVisibility(isShow: false)
        dismissRecentSearchContentViewController()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toggleCancelButtonVisibility(isShow: false)
        dismissRecentSearchContentViewController()
    }
    
    func toggleCancelButtonVisibility(isShow: Bool) {
        searchBar.setShowsCancelButton(isShow, animated: false)
        searchBar.resignFirstResponder()
    }
    
    func dismissRecentSearchContentViewController() {
        recentSearchContentViewController.willMove(toParent: nil)
        recentSearchContentViewController.view.removeFromSuperview()
        recentSearchContentViewController.removeFromParent()
    }
}

extension SearchContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell", for: indexPath)
        return cell
    }
}
