//
//  ShareViewController.swift
//  KkukShareExtension
//
//  Created by Yujin Kim on 2023-11-06.
//

import UIKit
import Social
import SnapKit

class ShareViewController: BaseUIViewController {
    private var sourceURL = ""
    
    private var isAddContent = true
    
//    private var modifyContent: Content?
    
    // MARK: - 컴포넌트

    private lazy var addContentButton = CompleteButton(frame: .zero)
    
    private lazy var induceURLLabel = InduceLabel(text: "링크 입력 및 붙여넣기", font: .title2)
    
    private lazy var induceMemoLabel = InduceLabel(text: "메모하기", font: .title2)
    
    private lazy var induceCategoryLabel = InduceLabel(text: "카테고리 선택하기", font: .title2)
    
    private lazy var optionalLabel = OptionalLabel(frame: .zero)
    
    private lazy var addCategoryButton = RedirectAddCategoryButton(frame: .zero)
    
    private lazy var memoContainerView = UIView()
    
    private lazy var URLTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .subgray3
        textField.clearButtonMode = .whileEditing
        textField.font = .body1
        textField.placeholder = "https://www.example.com"
        textField.tintColor = .main
        textField.layer.cornerRadius = CGFloat(8)
        textField.clipsToBounds = true
        return textField
    }()
    
    private lazy var URLTextFieldStateLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.font = .body3
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.isHidden = true
        return label
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.text = "메모할 내용을 입력"
        textView.textColor = .subgray1
        textView.isScrollEnabled = false
        textView.backgroundColor = .subgray3
        textView.tintColor = .main
        textView.font = .body1
        textView.layer.cornerRadius = CGFloat(8)
        textView.contentInset = UIEdgeInsets(top: 4, left: 4, bottom: 0, right: 4)
        return textView
    }()
    
    private lazy var memoTextCountLabel: UILabel = {
        let label = UILabel()
        label.font = .body3
        label.text = "0/75자"
        label.textColor = .subgray1
        return label
    }()
    
    private lazy var selectCategoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.register(SelectCategoryCell.self, forCellWithReuseIdentifier: "SetCategoryCell")
        return view
    }()
    
    override func setNavigationBar() {
        title = "추가하기"
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.title3 ]
        appearance.backgroundColor = .background
        appearance.shadowColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeButtonItemDidTap))
        navigationItem.rightBarButtonItem = closeButtonItem
    }

    override func setUI() {
        setNavigationBar()

        memoContainerView.addSubviews([memoTextView, memoTextCountLabel])

        view.addSubviews([induceURLLabel, induceMemoLabel, induceCategoryLabel, optionalLabel, URLTextField,
                          URLTextFieldStateLabel, memoContainerView, selectCategoryCollectionView, addContentButton, addCategoryButton])
    }
    
    override func setLayout() {
        induceURLLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        URLTextField.snp.makeConstraints {
            $0.top.equalTo(induceURLLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(48)
        }
        URLTextFieldStateLabel.snp.makeConstraints {
            $0.top.equalTo(URLTextField.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(induceURLLabel)
        }
        induceMemoLabel.snp.makeConstraints {
            $0.top.equalTo(URLTextFieldStateLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(induceURLLabel)
        }
        optionalLabel.snp.makeConstraints {
            $0.top.trailing.equalTo(induceMemoLabel)
            $0.height.equalTo(induceMemoLabel)
        }
        memoContainerView.snp.makeConstraints {
            $0.top.equalTo(induceMemoLabel.snp.bottom).offset(14)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(142)
        }
        memoTextView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        memoTextCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
            $0.bottom.equalToSuperview().offset(-8)
        }
        induceCategoryLabel.snp.makeConstraints {
            $0.top.equalTo(memoTextView.snp.bottom).offset(28)
            $0.leading.equalTo(induceURLLabel)
        }
        addCategoryButton.snp.makeConstraints {
            $0.top.equalTo(induceCategoryLabel)
            $0.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(induceCategoryLabel.snp.height)
        }
        selectCategoryCollectionView.snp.makeConstraints {
            $0.top.equalTo(induceCategoryLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(160)
        }
        addContentButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(60)
        }

    // 3: Define the actions for the navigation items
    @objc private func cancelAction () {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }

    @objc private func doneAction() {
        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
}
