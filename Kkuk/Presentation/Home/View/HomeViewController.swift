//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

import SnapKit

final class HomeViewController: BaseUIViewController, UIScrollViewDelegate {
    
    private var contentManager = ContentManager()
    
    private var recentItems: [Content] = [] {
        didSet {
            emptyLabel.isHidden = !recentItems.isEmpty
        }
    }
    
    private var topFrameView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .main
        
        return view
    }()
    
    private var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 마음에 드는 콘텐츠를, 꾹"
        label.font = .subtitle2
        label.textColor = .background
        
        return label
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        label.font = .title1
        label.textColor = .background
        
        return label
    }()
    
    private var recentLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 보관한 콘텐츠"
        label.font = .title3
        label.textColor = .text1
        
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
    
    private var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "최근에 추가한 콘텐츠가 없습니다."
        label.font = .subtitle1
        label.textColor = .subgray1
        
        return label
    }()
    
    private var recommendPagingView = RecommendPagingView()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
       
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        contentManager.getLocationOfDefaultRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItems()
    }
  
    override func setUI() {
        view.addSubviews([topFrameView, recentLabel, tableView, plusButton])
        
        topFrameView.addSubviews([subTitleLabel, titleLabel, recommendPagingView])
        
        tableView.addSubviews([emptyLabel])
    }
    
    private func updateItems() {
        let contents = contentManager.read()
        recentItems = contents.prefix(5).map { $0 as Content }
        tableView.reloadData()
        
        let isPinnedItems = contents.filter { $0.isPinned }
        recommendPagingView.setItems(items: isPinnedItems)
        
        recommendPagingView.itemStackView.subviews.forEach {
            let view = $0 as? RecommendView
            view?.delegate = self
        }
    }
    
    override func setLayout() {
        topFrameView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview()
            constraint.width.equalTo(view.safeAreaLayoutGuide)
            constraint.height.equalTo(view.snp.height).multipliedBy(0.55)
        }
        
        subTitleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.leading.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            constraint.leading.equalTo(20)
        }
        
        recentLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(topFrameView.snp.bottom).offset(18)
            constraint.leading.equalTo(20)
        }
        
        recommendPagingView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.equalToSuperview()
            constraint.top.equalTo(titleLabel.snp.bottom).offset(28)
            constraint.bottom.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { constraint in
            constraint.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            constraint.trailing.equalTo(-20)
            constraint.height.width.equalTo(60)
        }
        
        tableView.snp.makeConstraints { constraint in
            constraint.top.equalTo(recentLabel.snp.bottom).offset(16)
            constraint.leading.trailing.equalToSuperview().inset(20)
            constraint.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { constraint in
            constraint.centerX.centerY.equalToSuperview()
        }
    }
    
    override func setDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func addTarget() {
        plusButton.addTarget(self, action: #selector(plusButtonDidTap), for: .touchUpInside)
    }

}

// MARK: - 커스텀 메서드

extension HomeViewController {

    @objc
    private func plusButtonDidTap() {
        let viewController = AddContentViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true)
    }
  
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentTableViewCell",
                                                       for: indexPath) as? ContentTableViewCell
        else { return UITableViewCell() }
        let item = recentItems[indexPath.row]
        cell.delegate = self
        cell.configureCell(content: item, index: indexPath.row)
        cell.selectionStyle = .none
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension HomeViewController: ContentTableViewCellDelegate {
    func togglePin(index: Int) {
        contentManager.update(content: self.recentItems[index]) { [weak self] content in
            content.isPinned.toggle()
            self?.updateItems()
        }
    }
}

extension HomeViewController: RecommendViewDelegate {
    func selectedPin() {
        updateItems()
    }
}
