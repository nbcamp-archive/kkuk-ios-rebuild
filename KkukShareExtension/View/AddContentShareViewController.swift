//
//  AddContentShareViewController.swift
//  KkukShareExtension
//
//  Created by Yujin Kim on 2023-11-06.
//

import RealmSwift
import SnapKit

import Social
import UIKit

class AddContentShareViewController: UIViewController {
    
    private var URLLabel: String?
    
    private var contentHelper = ContentHelper()
    
    private var categoryHelper = CategoryHelper.shared
    
    private var categories = [Category]()
    
    private var selectedCategoryId: ObjectId?
    
    private var sourceURL = ""
    
    private var isAddContent = true
    
    private var modifyContent: Content?

    private lazy var addContentButton = CompleteButton(frame: .zero)
    
    private lazy var induceURLLabel = InduceLabel(text: "가져온 콘텐츠 링크", font: .title2)
    
    private lazy var induceMemoLabel = InduceLabel(text: "메모하기", font: .title2)
    
    private lazy var induceCategoryLabel = InduceLabel(text: "카테고리 선택하기", font: .title2)
    
    private lazy var optionalLabel = OptionalLabel(frame: .zero)
    
    private lazy var memoContainerView = UIView()
    
    private lazy var URLTextLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle2
        label.textColor = .subgray1
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = false
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
        
        view.backgroundColor = .background
        setNavigationBar()
        setUI()
        setLayout()
        setDelegate()
        addTarget()
        
        categories = categoryHelper.read()
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        selectedCategoryId = categories[indexPath.row].id
        selectCategoryCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
    }
    
    private func setNavigationBar() {
        navigationItem.title = "콘텐츠 추가하기"
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = closeButtonItem
    }

    private func setUI() {
        memoContainerView.addSubviews([memoTextView, memoTextCountLabel])
        
        view.addSubviews([induceURLLabel, induceMemoLabel, induceCategoryLabel, optionalLabel,
                          URLTextLabel, memoContainerView, selectCategoryCollectionView, addContentButton])
        
        addContentButton.setUI(to: .enable)
        didSelectPost()
    }
    
    private func setLayout() {
        induceURLLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        URLTextLabel.snp.makeConstraints {
            $0.top.equalTo(induceURLLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(induceURLLabel)
            $0.height.equalTo(48)
        }
        induceMemoLabel.snp.makeConstraints {
            $0.top.equalTo(URLTextLabel.snp.bottom).offset(8)
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
    }
    
    private func setDelegate() {
        memoTextView.delegate = self
    }
    
    private func addTarget() {
        addContentButton.addTarget(self, action: #selector(addContentButtonDidTap), for: .touchUpInside)
    }

}

// MARK: - @objc

extension AddContentShareViewController {
    
    @objc
    private func cancelAction() {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey: "An error description"])
        extensionContext?.cancelRequest(withError: error)
    }
    
    @objc
    private func addContentButtonDidTap() {
        addContentButton.isEnabled = false
        updateActivityIndicatorState(true)
        
        guard let text = URLTextLabel.text, !text.isEmpty, let URL = URL(string: text) else { return }
        
        let openGraphService = OpenGraphService()
        
        openGraphService.extractOpenGraphData(from: URL) { [weak self] result in
            switch result {
            case .success(let openGraph):
                guard let isAddContent = self?.isAddContent else { return }
                
                if isAddContent {
                    let newContent = Content(sourceURL: text,
                                             title: openGraph.ogTitle ?? "",
                                             imageURL: openGraph.ogImage,
                                             memo: self?.memoTextView.text == "메모할 내용을 입력" ? "" : self?.memoTextView.text ,
                                             category: (self?.selectedCategoryId)!)
                    self?.contentHelper.create(content: newContent)
                    self?.updateActivityIndicatorState(false)
                    self?.addContentButton.isEnabled = true
                } else {
                    guard let modifyContent = self?.modifyContent else { return }
                    
                    self?.contentHelper.update(content: modifyContent, completion: { content in
                        content.sourceURL = text
                        content.memo = self?.memoTextView.text
                        content.category = (self?.selectedCategoryId)!
                    })
                }
                
                let title = isAddContent ? "콘텐츠를 추가했어요" : "콘텐츠를 수정했어요"
                
                let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                })
                
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
                
                print("ogURL: \(openGraph.ogURL ?? "No Data")")
                print("ogTitle: \(openGraph.ogTitle ?? "No Data")")
                print("ogGraph: \(openGraph.ogImage ?? "No Data")")
            case .failure(let error):
                print("Open Graph Data를 추출하는데 문제가 발생했습니다. \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self?.updateActivityIndicatorState(false)
                    self?.addContentButton.isEnabled = false
                }
            }
        }
    }
    
}

// MARK: - 커스텀 메서드

extension AddContentShareViewController {
    
    private func updateActivityIndicatorState(_ isEnabled: Bool) {
        addContentButton.configuration?.showsActivityIndicator = isEnabled
    }
    
    private func didSelectPost() {
        guard let contextItem = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        
        guard let provider = contextItem.attachments?.first as? NSItemProvider else { return }
        
        provider.loadItem(forTypeIdentifier: "public.url", options: nil) { [weak self] url, _ in
            guard let self = self else { return }
            
            if let shareUrl = url as? URL {
                let urlLabel = shareUrl.absoluteString
                DispatchQueue.main.async {
                    self.URLTextLabel.text = urlLabel
                }
            }
        }
    }

}

// MARK: - 텍스트 뷰 델리게이트

extension AddContentShareViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = .background
        textView.layer.borderColor = UIColor.main.cgColor
        textView.layer.borderWidth = CGFloat(2)
        textView.layer.cornerRadius = CGFloat(8)
        textView.layer.masksToBounds = true
        textView.text = nil
        textView.textColor = .text1
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        textView.textColor = .text1
        textView.backgroundColor = .subgray3
        textView.layer.borderWidth = CGFloat(0)
        textView.layer.borderColor = .none

        if textView.text.isEmpty == true {
            textView.text = "메모할 내용을 입력"
            textView.textColor = .subgray1
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

extension AddContentShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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

extension AddContentShareViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 4) - 4
        return CGSize(width: width, height: 48)
    }
    
}
