//
//  AddContentViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import Alamofire
import SwiftSoup
import SnapKit
import RealmSwift

import UIKit

class AddContentViewController: BaseUIViewController {
    
    // MARK: - 프로퍼티
    
    private var contentManager = ContentManager()
    
    private var categoryManager = RealmCategoryManager.shared
    
    private var categories = [Category]()
    
    private var selectedCategoryId: ObjectId?
    
    private var sourceURL = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = categoryManager.read()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setIQKeyboardManagerEnable(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setIQKeyboardManagerEnable(false)
    }
    
    override func setNavigationBar() {
        title = "추가하기"
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.title3 ]
        appearance.backgroundColor = .white
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
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
            $0.trailing.equalTo(-20)
            $0.height.equalTo(160)
        }
        addContentButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(60)
        }
    }
    
    override func setDelegate() {
        URLTextField.delegate = self
        memoTextView.delegate = self
    }
    
    override func addTarget() {
        addContentButton.addTarget(self, action: #selector(addContentButtonDidTap), for: .touchUpInside)
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        URLTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
}

// MARK: - 커스텀 메서드

extension AddContentViewController {
    
    private func updateAddContentButtonState(with text: String) {
        if isValidURL(with: sourceURL), !sourceURL.isEmpty {
            addContentButton.setUI(to: .enable)
            URLTextFieldStateLabel.isHidden = false
            URLTextFieldStateLabel.textColor = .systemBlue
            URLTextFieldStateLabel.text = "올바른 형식의 링크입니다."
        }
        
        if sourceURL.isEmpty {
            addContentButton.setUI(to: .disable)
            URLTextFieldStateLabel.isHidden = false
            URLTextFieldStateLabel.textColor = .systemRed
            URLTextFieldStateLabel.text = "링크를 추가해야 합니다."
        }
        
        if sourceURL.range(of: ".*[ㄱ-ㅎㅏ-ㅣ가-힣]+.*", options: .regularExpression) != nil {
            addContentButton.setUI(to: .disable)
            URLTextFieldStateLabel.isHidden = false
            URLTextFieldStateLabel.textColor = .systemRed
            URLTextFieldStateLabel.text = "지원하지 않는 형식의 링크입니다."
        }
    }
    
    private func isValidURL(with text: String) -> Bool {
        if let url = NSURL(string: text) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
}

// MARK: - @objc

extension AddContentViewController {
    
    @objc
    func textFieldDidChange(_ textField: UITextField) {
        sourceURL = URLTextField.text ?? ""
        updateAddContentButtonState(with: sourceURL)
    }
    
    @objc
    private func closeButtonItemDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func addContentButtonDidTap() {
        guard let text = URLTextField.text, !text.isEmpty, let URL = URL(string: text) else { return }
        
        let openGraphService = OpenGraphService()
        
        openGraphService.extractOpenGraphData(from: URL) { [weak self] result in
            switch result {
            case .success(let openGraph):
                let newContent = Content(sourceURL: text,
                                         title: openGraph.ogTitle ?? "",
                                         imageURL: openGraph.ogImage,
                                         memo: self?.memoTextView.text,
                                         category: (self?.selectedCategoryId)!)
                self?.contentManager.create(content: newContent)
                
                self?.dismiss(animated: true)
                
                print("ogURL: \(openGraph.ogURL ?? "No data")")
                print("ogTitle: \(openGraph.ogTitle ?? "No data")")
                print("ogGraph: \(openGraph.ogImage ?? "No data")")
            case .failure(let error):
                print("Open Graph Property Data를 추출하는데 문제가 발생했습니다. \(error.localizedDescription)")
            }
        }
    }
    
    @objc
    private func addCategoryButtonDidTap() {
        let viewController = AddCategoryViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

// MARK: - 텍스트필드 델리게이트

extension AddContentViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        URLTextField.backgroundColor = .background
        URLTextField.layer.borderWidth = CGFloat(2)
        URLTextField.layer.cornerRadius = CGFloat(8)
        URLTextField.layer.borderColor = UIColor.main.cgColor
        URLTextField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        URLTextField.backgroundColor = .subgray3
        URLTextField.layer.borderWidth = CGFloat(0)
        URLTextField.layer.borderColor = .none
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updateText = (sourceURL as NSString).replacingCharacters(in: range, with: string)
        
        updateAddContentButtonState(with: updateText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        URLTextField.resignFirstResponder()
        return true
    }
    
}

// MARK: - 텍스트 뷰 델리게이트

extension AddContentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoTextView.backgroundColor = .background
        memoTextView.layer.borderColor = UIColor.main.cgColor
        memoTextView.layer.borderWidth = CGFloat(2)
        memoTextView.layer.cornerRadius = CGFloat(8)
        memoTextView.layer.masksToBounds = true
        
        if memoTextView.textColor == .subgray1 {
            memoTextView.text = nil
            memoTextView.textColor = .text1
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.textColor = .text1
        memoTextView.backgroundColor = .subgray3
        memoTextView.layer.borderWidth = CGFloat(0)
        memoTextView.layer.borderColor = .none
        
        if memoTextView.textColor == .subgray1 {
            memoTextView.text = "메모가 필요한 경우 내용을 작성할 수 있습니다. (선택)"
            memoTextView.textColor = .subgray1
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        memoTextCountLabel.text = "\(count)/75자"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentMemoText = memoTextView.text ?? ""
        guard let stringRange = Range(range, in: currentMemoText) else { return false }
        
        let updateMemoText = currentMemoText.replacingCharacters(in: stringRange, with: text)
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return updateMemoText.count <= 75
    }
    
}

// MARK: - 콜렉션 뷰 델리게이트

extension AddContentViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        selectedCategoryId = category.id
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectCategoryCell {
            cell.isSelected = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectCategoryCell {
            cell.isSelected = false
        }
    }
    
}

// MARK: - 콜렉션 뷰 DataSource

extension AddContentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SetCategoryCell", for: indexPath) as? SelectCategoryCell else {
            return UICollectionViewCell()
        }
        
        let category = categories[indexPath.item]
        cell.configure(with: category)
        
        return cell
    }
    
}

// MARK: - 콜렉션 뷰 FlowLayout 델리게이트

extension AddContentViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 4) - 4
        return CGSize(width: width, height: 48)
    }
    
}
