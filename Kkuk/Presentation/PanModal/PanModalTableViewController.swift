//
//  PanModalTableViewController.swift
//  Kkuk
//
//  Created by 장가겸 on 10/25/23.
//

import PanModal
import Kingfisher
import SnapKit
import UIKit
import RealmSwift

protocol PanModalTableViewControllerDelegate: AnyObject {
    func modifyTitle(title: String)
}

class PanModalTableViewController: BaseUIViewController {
    private var category: Category?

    private var modifyTitle: String?

    weak var delegate: PanModalTableViewControllerDelegate?
    
    private var panModalOption: PanModalOption?
    
    private var content: Content?
    
    private var helper = ContentHelper()
    
    weak var selfNavi: UINavigationController?
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    private lazy var modifyView: UIView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 16
        view.layer.cornerRadius = 8
        view.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        view.backgroundColor = .background
        view.isHidden = true
        return view
    }()
    
    private lazy var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.subgray2.cgColor
        imageView.layer.borderWidth = 0.5
        return imageView
    }()
    
    private lazy var siteTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "사이트 타이틀 라벨"
        label.font = .subtitle1
        label.textColor = .text1
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모 라벨"
        label.font = .subtitle3
        label.textColor = .text1
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.text = "URL 라벨"
        label.font = .subtitle4
        label.textColor = .subgray1
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private lazy var deleteModifyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PanModalTableViewCell.self, forCellReuseIdentifier: "PanModalTableViewCell")
        tableView.allowsSelection = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.contentInset = .zero
        tableView.estimatedRowHeight = 34
        return tableView
    }()
    
    func configureCell() {
        siteTitleLabel.text = content?.title
        memoLabel.text = content?.memo
        urlLabel.text = content?.sourceURL
        setUpImage(imageURL: content?.imageURL)
    }
    
    func setUpImage(imageURL: String?) {
        guard var url = imageURL else { return }
        
        // http 포함 -> https로 변경
        if url.contains("http:") {
            if let range = url.range(of: "http:") {
                url.replaceSubrange(range, with: "https:")
            }
            // http 미포함 -> https를 접두에 추가
            // (이 조건은 https가 포함되어 있을 때도 만족하기 때문에 조건에서 제거해줘야함)
        } else if !url.contains("https:") {
            url = "https:" + url
        }
        
        guard let https = url.range(of: "https:") else { return }
        
        url = String(url.suffix(from: https.lowerBound))
        
        // 내가 추가한거
        guard let urlSource = URL(string: url) else { return }
        // 내가 추가한거
        thumbnailImageView.kf.setImage(with: urlSource)
    }
    
    init(option: PanModalOption, content: Content? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.panModalOption = option
        self.content = content
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUI() {
        view.addSubviews([deleteModifyTableView, modifyView, backView])
        modifyView.addSubviews([thumbnailImageView, siteTitleLabel, memoLabel, urlLabel])
        view.backgroundColor = .clear
        if content != nil {
            configureCell()
            modifyView.isHidden = false
            addTopBorder(with: UIColor.selected, andWidth: 0.5)
        } else {
            deleteModifyTableView.layer.cornerRadius = 8
            deleteModifyTableView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        }
    }

    /// 화면 레이아웃을 설정하기 위한 사용자 정의 함수입니다.
    override func setLayout() {
        modifyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteModifyTableView.snp.top)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(modifyView).offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(UIScreen.main.bounds.height * 0.1)
        }
        
        siteTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(thumbnailImageView)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.top.equalTo(siteTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(modifyView).inset(12)
        }
        
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(memoLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(modifyView).inset(12)
            make.bottom.equalTo(modifyView).offset(-12)
        }

        deleteModifyTableView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height * 0.25)
            make.leading.trailing.equalTo(modifyView)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(deleteModifyTableView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    /// 델리게이트 설정을 위한 사용자 정의 함수입니다.
    override func setDelegate() {
        deleteModifyTableView.delegate = self
        deleteModifyTableView.dataSource = self
        deleteModifyTableView.allowsSelection = true
    }

    override func viewWillAppear(_ animated: Bool) {
        delegate?.modifyTitle(title: modifyTitle ?? category!.name)
    }

    private func presentDeleteAlert() {
        
        let title = panModalOption?.screenType == .category ? "카테고리" : "콘텐츠"
        
        showAlertTwoButton(title: "\(title)를 삭제하시겠습니까?", message: nil, actionCompletion: {
            
            switch self.panModalOption?.screenType {
            case .category:
                guard let category = self.category else { return }
                
                // ContentHelper 인스턴스를 생성
                let contentHelper = ContentHelper()
                
                // 카테고리에 속한 콘텐츠를 찾아서 삭제
                let contentsToDelete = contentHelper.readInCategory(at: category.id)
                for content in contentsToDelete {
                    contentHelper.delete(content)
                }

                // CategoryHelper를 사용하여 카테고리 삭제
                CategoryHelper.shared.delete(category)
                
                // 뷰 컨트롤러 닫기
            case .content:
                guard let content = self.content else { return }
                self.helper.delete(content)
            default: return
            }

            self.selfNavi?.popToRootViewController(animated: true)
            self.dismiss(animated: true)
        })
    }
    
    func addTopBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: deleteModifyTableView.frame.width, height: borderWidth)
        deleteModifyTableView.addSubview(border)
    }

}

extension PanModalTableViewController {
    func setCategory(category: Category) {
        self.category = category
    }
}

extension PanModalTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = panModalOption?.title.count else { return 0 }
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let title = panModalOption?.title[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PanModalTableViewCell",
                                                       for: indexPath) as? PanModalTableViewCell else { return UITableViewCell() }
        cell.configure(name: title.rawValue)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let count = panModalOption?.title.count else { return 0 }
        return (UIScreen.main.bounds.height * 0.25 ) / CGFloat(count)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menu = panModalOption?.title[indexPath.row] else { return }
        switch panModalOption?.screenType {
        case .category: didSelectedCategoryScreen(menu)
        case .content: didSelectedContentScreen(menu)
        default: return
        }
    }
    
    func didSelectedCategoryScreen(_ menu: PanModalOption.Title) {
        switch menu {
        case .modify:
            
            let viewController = AddCategoryViewController(isAddCategory: false, modifyCategory: category)
            viewController.delegate = self
            presentFromPanModal(to: viewController)
        case .delete:
            self.presentDeleteAlert()
        case .cancel:
            dismiss(animated: true)
        default:
            return
        }
    }
    
    func didSelectedContentScreen(_ menu: PanModalOption.Title) {
        guard let content = content else { return }
        
        switch menu {
        case .modify:
            let viewController = AddContentViewController(isAddContent: false, modifyContent: content)
            presentFromPanModal(to: viewController)
        case .delete:
            presentDeleteAlert()
        case .share:
            guard let url = URL(string: content.sourceURL) else { return }
            let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            present(activityViewController, animated: true)
        case .cancel: dismiss(animated: true)
        }
    }
    
    func presentFromPanModal(to viewController: UIViewController) {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical
        present(navigationController, animated: true)
    }
}

extension PanModalTableViewController: PanModalPresentable {
    var topOffset: CGFloat {
        0
    }
    
    var panScrollable: UIScrollView? {
        nil
    }

    var shortFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 1)
    }

    var longFormHeight: PanModalHeight {
        .contentHeight(UIScreen.main.bounds.height * 1)
    }
    
    var allowsTapToDismiss: Bool {
        false
    }
    
    var allowsDragToDismiss: Bool {
        false
    }
    
    var dragIndicatorBackgroundColor: UIColor {
        .clear
    }
}

extension PanModalTableViewController: AddCategoryViewControllerDelegate {
    func reloadTableView() {}
}
