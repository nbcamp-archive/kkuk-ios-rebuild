//
//  SearchContentViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class SearchContentViewController: BaseUIViewController {
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "검색어를 입력하세요"
        searchBar.delegate = self
        
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
        return tableView
    }()

    override func setUI() {
        view.addSubviews([searchBar, contentTableView])
    }
    
    override func setLayout() {
        setSearchBarLayout()
        setContentTableViewLayout()
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
}

extension SearchContentViewController: UISearchBarDelegate {
    
}

extension SearchContentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
