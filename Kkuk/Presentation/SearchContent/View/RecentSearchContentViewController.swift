//
//  RecentSearchContentViewController.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/18.
//

import UIKit

class RecentSearchContentViewController: BaseUIViewController {
    let cellSpacing: CGFloat = 16
    let cellHeight: CGFloat = 16
    
    let manager = RecentSearchManager()
    
    var searchList: [String] = []

    private lazy var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .text1
        label.font = .subtitle2
        label.textAlignment = .left
       
        return label
    }()
    
    private lazy var allDelegateButton: UIButton = {
        let button = UIButton()
        button.setTitle("전체 삭제", for: .normal)
        button.setTitleColor(.subgray2, for: .normal)
        button.titleLabel?.font = .subtitle4
        return button
    }()

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RecentSearchContentCollectionViewCell.self, forCellWithReuseIdentifier: "RecentSearchContentCollectionViewCell")
        
        return collectionView
    }()
    
    private lazy var noRecentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어가 없습니다"
        label.font = .subtitle2
        label.textColor = .text1
        label.numberOfLines = 1
        label.textAlignment = .center
        label.isHidden = !searchList.isEmpty
        return label
    }()
    
    override func setUI() {
        searchList = manager.fetchAllSearches()
        
        view.addSubviews([recentSearchesLabel,
                          allDelegateButton,
                          collectionView,
                          noRecentSearchesLabel])
    }
    
    override func setLayout() {
        setRecentSearchesLabel()
        setAllDeleteButton()
        setCollectionViewLayout()
        setNoRecentSearchesLabelLayout()
    }
    
    override func addTarget() {
        allDelegateButton.addTarget(self, action: #selector(deleteAllSearches), for: .touchUpInside)
    }
    
    func setRecentSearchesLabel() {
        recentSearchesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview()
        }
    }
    
    func setAllDeleteButton() {
        allDelegateButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchesLabel)
            make.trailing.equalToSuperview()
        }
    }
    
    func setCollectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(32)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setNoRecentSearchesLabelLayout() {
        noRecentSearchesLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func deleteAllSearches() {
        manager.deleteAllSearches()
    }
}

extension RecentSearchContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "RecentSearchContentCollectionViewCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                         for: indexPath) as? RecentSearchContentCollectionViewCell {
            cell.addSearchWordLabel(text: searchList[indexPath.row])
            cell.addDeleteButton(tag: indexPath.row)
            return cell
        }
        
        return BaseUICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - cellSpacing
        return CGSize(width: width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let searchContentViewController = parent as? SearchContentViewController {
            searchContentViewController.toggleContainerViewVisibility(isShow: false)
         }
    }
}
