//
//  RecentSearchContentViewController.swift
//  Kkuk
//
//  Created by Jooyeon Kang on 2023/10/18.
//

import UIKit

class RecentSearchContentViewController: BaseUIViewController {
    private lazy var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .text1
        label.font = .subtitle2
        label.textAlignment = .left
       
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BaseUICollectionViewCell.self, forCellWithReuseIdentifier: "BaseUICollectionViewCell")
        return collectionView
    }()

    
    override func setUI() {
        view.addSubviews([recentSearchesLabel, collectionView])

    }
    
    override func setLayout() {
        setRecentSearchesLabel()
        setCollectionViewLayout()
    }
    
    func setRecentSearchesLabel() {
        recentSearchesLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setCollectionViewLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchesLabel.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension RecentSearchContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseUICollectionViewCell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}
