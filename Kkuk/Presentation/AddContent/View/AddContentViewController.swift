//
//  AddContentViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import Alamofire
import SwiftSoup
import SnapKit

import UIKit

class AddContentViewController: BaseUIViewController {
    
    private lazy var contentManager = ContentManager()
    
    private lazy var addContentButton = AddContentButton(frame: .zero)
    
    private lazy var induceURLLabel = InduceLabel(text: "링크 입력 및 붙여넣기", font: .title2)
    
    private lazy var induceMemoLabel = InduceLabel(text: "메모하기", font: .title2)
    
    private lazy var induceCategoryLabel = InduceLabel(text: "카테고리 선택하기", font: .title2)
    
    private lazy var memoContainerView = UIView()
    
    private lazy var URLTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .subgray3
        textField.clearButtonMode = .whileEditing
        textField.font = .body1
        textField.placeholder = "https://www.example.com"
        textField.tintColor = .main
        return textField
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .text1
        textView.isScrollEnabled = false
        textView.backgroundColor = .subgray3
        textView.tintColor = .main
        textView.font = .body1
        textView.layer.cornerRadius = CGFloat(5)
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
    
    private lazy var requiredLabel: UILabel = {
        let label = UILabel()
        label.text = "필수"
        label.font = .body3
        label.textColor = .subgray1
        return label
    }()
    
    private lazy var optionalLabel: UILabel = {
        let label = UILabel()
        label.text = "선택"
        return label
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .close)
        barButtonItem.target = self
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        URLTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setIQKeyboardManagerEnable(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setIQKeyboardManagerEnable(false)
    }
    
    override func setUI() {
        setNavigationBar()
        
        memoContainerView.addSubviews([memoTextView, memoTextCountLabel])
        
        view.addSubviews([induceURLLabel, induceMemoLabel, induceCategoryLabel,
                          URLTextField, memoContainerView, addContentButton])
    }
    
    override func setLayout() {
        induceURLLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            $0.leading.equalTo(20)
        }
        URLTextField.snp.makeConstraints {
            $0.top.equalTo(induceURLLabel.snp.bottom).offset(14)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
            $0.height.equalTo(48)
        }
        induceMemoLabel.snp.makeConstraints {
            $0.top.equalTo(URLTextField.snp.bottom).offset(20)
            $0.leading.equalTo(induceURLLabel)
        }
        memoContainerView.snp.makeConstraints {
            $0.top.equalTo(induceMemoLabel.snp.bottom).offset(14)
            $0.leading.equalTo(induceURLLabel)
            $0.trailing.equalTo(-20)
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
            $0.top.equalTo(memoTextView.snp.bottom).offset(20)
            $0.leading.equalTo(induceURLLabel)
        }
        addContentButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    override func setDelegate() {
        URLTextField.delegate = self
        memoTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func addTarget() {
        addContentButton.addTarget(self, action: #selector(addContentButtonDidTap), for: .touchUpInside)
    }
    
    override func setNavigationBar() {
        title = "추가하기"
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.title3 ]
        appearance.backgroundColor = .white
        appearance.shadowColor = .none
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self,
                                              action: #selector(closeButtonItemDidTap))
        navigationItem.rightBarButtonItem = closeButtonItem
    }
    
}

// MARK: - 커스텀 메서드

extension AddContentViewController {
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = view.convert(keyboardFrame, from: nil).size.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.addContentButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.addContentButton.transform = .identity
            self?.view.layoutIfNeeded()
        }
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
                                         memo: self?.memoTextView.text)
                self?.contentManager.create(content: newContent)
                
                print("ogURL: \(openGraph.ogURL ?? "No data")")
                print("ogTitle: \(openGraph.ogTitle ?? "No data")")
                print("ogGraph: \(openGraph.ogImage ?? "No data")")
            case .failure(let error):
                print("Open Graph Property Data를 추출하는데 문제가 발생했습니다. \(error.localizedDescription)")
            }
        }
    }
    
}

// MARK: - UITextField 델리게이트

extension AddContentViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        URLTextField.backgroundColor = .background
        URLTextField.layer.borderWidth = CGFloat(2)
        URLTextField.layer.cornerRadius = CGFloat(5)
        URLTextField.layer.borderColor = UIColor.main.cgColor
        URLTextField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        URLTextField.backgroundColor = .subgray3
        URLTextField.layer.borderWidth = CGFloat(0)
        URLTextField.layer.borderColor = .none
        addContentButton.updateButtonState(with: URLTextField.text)
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let updateText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        addContentButton.updateButtonState(with: updateText)
        return true
    }
    
}

// MARK: - UITextView 델리게이트

extension AddContentViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let memoTextViewPlaceholder = "내용"
        if textView.text == memoTextViewPlaceholder {
            textView.text = nil
        }
        
        memoTextView.backgroundColor = .background
        memoTextView.layer.borderColor = UIColor.main.cgColor
        memoTextView.layer.borderWidth = CGFloat(2)
        memoTextView.layer.cornerRadius = CGFloat(5)
        memoTextView.layer.masksToBounds = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let memoTextViewPlaceholder = "내용"
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = memoTextViewPlaceholder
            textView.textColor = .subgray1
        }
        
        memoTextView.backgroundColor = .subgray3
        memoTextView.layer.borderWidth = CGFloat(0)
        memoTextView.layer.borderColor = .none
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = textView.text.count
        memoTextCountLabel.text = "\(count)/75자"
        if count >= 75 {
            memoTextCountLabel.textColor = .red
        } else {
            memoTextCountLabel.textColor = .subgray1
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentMemoText = memoTextView.text ?? ""
        guard let stringRange = Range(range, in: currentMemoText) else { return false }
        
        let updateMemoText = currentMemoText.replacingCharacters(in: stringRange, with: text)
        return updateMemoText.count <= 75
    }
    
}

class ExtractOpenGraphTestViewController: BaseUIViewController {
    
    private lazy var opengraphImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var opengraphTitle: UILabel = {
        let label = UILabel()
        label.font = .body1
        return label
    }()
    
    private lazy var opengraphDescription: UITextView = {
        let view = UITextView()
        view.font = .body2
        return view
    }()
    
    var openGraphData: [String: String]? {
        didSet {
            bind()
        }
    }
    
    override func setUI() {
        view.addSubviews([opengraphImageView, opengraphTitle, opengraphDescription])
    }
    
    override func setLayout() {
        opengraphImageView.snp.makeConstraints { constraint in
            constraint.centerX.equalToSuperview()
            constraint.top.equalTo(view.safeAreaLayoutGuide)
            constraint.width.equalTo(150)
            constraint.height.equalTo(300)
        }
        
        opengraphTitle.snp.makeConstraints { constraint in
            constraint.top.equalTo(opengraphImageView.snp.bottom).offset(20)
            constraint.leading.equalToSuperview().offset(20)
            constraint.trailing.equalToSuperview().offset(-20)
        }
        
        opengraphDescription.snp.makeConstraints { constraint in
            constraint.top.equalTo(opengraphTitle.snp.bottom).offset(20)
            constraint.leading.equalToSuperview().offset(20)
            constraint.trailing.equalToSuperview().offset(-20)
            constraint.width.equalTo(250)
            constraint.height.equalTo(500)
        }
    }
    
}

extension ExtractOpenGraphTestViewController {
    
    private func bind() {
        if let openGraphData = openGraphData {
            if let imageURLString = openGraphData["og:image"],
               let imageURL = URL(string: imageURLString) {
                
                AF.request(imageURL).responseData { response in
                    if case .success(let image) = response.result {
                        DispatchQueue.main.async {
                            let image = UIImage(data: image)
                            self.opengraphImageView.image = image
                        }
                    }
                }
            }
            
            if let title = openGraphData["og:title"] {
                opengraphTitle.text = title
            }
            
            if let description = openGraphData["og:description"] {
                opengraphDescription.text = description
            }
        }
    }
}
