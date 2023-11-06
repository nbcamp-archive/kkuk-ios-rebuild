//
//  HomeViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit
import RealmSwift
import SnapKit

final class HomeViewController: BaseUIViewController, UIScrollViewDelegate {
    private var contentManager = ContentManager()
    
    private var recentItems: [Content] = [] {
        didSet {
            emptyLabel.isHidden = !recentItems.isEmpty
        }
    }
    
    private var bookmarkItems: [Content] = [] {
        didSet {
            pageControl.numberOfPages = bookmarkItems.count
            emptyStateView.isHidden = !bookmarkItems.isEmpty
        }
    }
    
    private var topFrameView: UIView = {
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
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPage = 0
        control.pageIndicatorTintColor = .subgray2
        control.currentPageIndicatorTintColor = .white
        
        return control
    }()
    
    private var emptyStateView = EmptyStateView()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.register(BookmarkCell.self, forCellWithReuseIdentifier: BookmarkCell.identifier)
        view.isPagingEnabled = true
        view.backgroundColor = .main
        view.backgroundView = emptyStateView
        view.bounces = false
        
        return view
    }()
    
    private var tableView: UITableView = {
        let view = UITableView()
        view.register(ContentTableViewCell.self, forCellReuseIdentifier: "ContentTableViewCell")
        view.showsVerticalScrollIndicator = false
       
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        contentManager.getLocationOfDefaultRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
  
    override func setUI() {
        view.addSubviews([topFrameView, recentLabel, tableView, plusButton])
        
        topFrameView.addSubviews([subTitleLabel, titleLabel, collectionView, pageControl])
        
        tableView.addSubviews([emptyLabel])
    }
    
    private func updateUI() {
        let contents = contentManager.read()
        recentItems = contents.prefix(5).map { $0 as Content }
        bookmarkItems = contents.filter { $0.isPinned }.prefix(5).map { $0 as Content }
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    private func updatePin(index: Int) {
        let contents = contentManager.read()
        bookmarkItems = contents.filter { $0.isPinned }.prefix(5).map { $0 as Content }
        collectionView.reloadData()
        tableView.reloadRows(at: [.init(row: index, section: 0)], with: .automatic)
    }
    
    override func setLayout() {
        topFrameView.snp.makeConstraints { constraint in
            constraint.top.equalToSuperview()
            constraint.horizontalEdges.equalToSuperview()
            constraint.height.equalTo(view.snp.height).multipliedBy(0.55)
        }
        
        subTitleLabel.setContentHuggingPriority(.required, for: .vertical)
        subTitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        subTitleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.leading.equalTo(20)
        }
        
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(subTitleLabel.snp.bottom).offset(8)
            constraint.leading.equalTo(20)
        }
        
        recentLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(topFrameView.snp.bottom).offset(18)
            constraint.leading.equalTo(20)
        }
        
        collectionView.snp.makeConstraints { constraint in
            constraint.horizontalEdges.equalToSuperview()
            constraint.top.equalTo(titleLabel.snp.bottom).offset(20)
            constraint.bottom.equalTo(pageControl.snp.top).offset(-12)
        }
        
        pageControl.snp.makeConstraints { constraint in
            constraint.bottom.equalToSuperview().offset(-12)
            constraint.centerX.equalToSuperview()
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
        collectionView.delegate = self
        collectionView.dataSource = self
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
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarkCell.identifier,
                                                            for: indexPath) as? BookmarkCell
        else { return .init() }
        
        let content = bookmarkItems[indexPath.row]
        cell.configureCell(content: content)
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = bookmarkItems[indexPath.item]
        
        let url = item.sourceURL
        let title = item.title
        
        let viewController = WebViewController(sourceURL: url, sourceTitle: title)
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(view.frame.width-40),
                                                            heightDimension: .fractionalHeight(1.0)))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                         heightDimension: .fractionalHeight(1.0)),
                                                       subitems: [item])
    
        group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, _, _ in
            self?.pageControl.currentPage = visibleItems.last?.indexPath.row ?? 0
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension HomeViewController: ContentTableViewCellDelegate {
    func togglePin(index: Int) {
        contentManager.update(content: self.recentItems[index]) { [weak self] content in
            content.isPinned.toggle()
            self?.updatePin(index: index)
        }
    }
}

extension HomeViewController: BookmarkCellDelegate {
    func removePin(id: ObjectId) {
        if let index = recentItems.firstIndex(where: { $0.id == id }) {
            self.updatePin(index: index)
        }
    }
}
