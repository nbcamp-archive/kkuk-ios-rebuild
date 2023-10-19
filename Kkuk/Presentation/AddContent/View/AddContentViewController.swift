//
//  AddContentViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import SnapKit
import UIKit

class AddContentViewController: BaseUIViewController {
    
    private let memoTextViewMaxHeight: CGFloat = 142
    
    private lazy var induceURLLabel: UILabel = {
        let label = UILabel()
        label.text = "링크 입력 및 붙여넣기"
        label.font = .title2
        label.textColor = .text1
        return label
    }()
    
    private lazy var induceMemoLabel: UILabel = {
        let label = UILabel()
        label.text = "메모하기"
        label.font = .title2
        label.textColor = .text1
        return label
    }()
    
    private lazy var induceCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 선택하기"
        label.font = .title2
        return label
    }()
    
    private lazy var URLTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "https://www.example.com"
        textField.backgroundColor = .subgray3
        textField.tintColor = .main
        textField.font = .body1
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.backgroundColor = .subgray3
        textView.tintColor = .main
        textView.font = .body1
        textView.layer.cornerRadius = CGFloat(5)
        textView.contentInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        return textView
    }()
    
    private lazy var memoTextCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/75자"
        return label
    }()
    
    override func setUI() {
        memoTextView.addSubview(memoTextCountLabel)
        view.addSubviews([induceURLLabel, induceMemoLabel, induceCategoryLabel,
                          URLTextField, memoTextView])
    }
    
    override func setLayout() {
        induceURLLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            constraint.leading.equalTo(20)
        }
        URLTextField.snp.makeConstraints { constraint in
            constraint.top.equalTo(induceURLLabel.snp.bottom).offset(14)
            constraint.leading.equalTo(20)
            constraint.trailing.equalTo(-20)
            constraint.height.equalTo(48)
        }
        induceMemoLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(URLTextField.snp.bottom).offset(20)
            constraint.leading.equalTo(induceURLLabel)
        }
        memoTextView.snp.makeConstraints { constraint in
            constraint.top.equalTo(induceMemoLabel.snp.bottom).offset(14)
            constraint.leading.equalTo(induceURLLabel)
            constraint.trailing.equalTo(-20)
            constraint.height.equalTo(48)
        }
        induceCategoryLabel.snp.makeConstraints { constraint in
            constraint.top.equalTo(memoTextView.snp.bottom).offset(20)
            constraint.leading.equalTo(induceURLLabel)
        }
    }
    
    override func setDelegate() {
        URLTextField.delegate = self
        memoTextView.delegate = self
    }
    
    override func addTarget() {
        let endEditingGesture = UITapGestureRecognizer(target: self, action: #selector(endEditingDidTap))
        view.addGestureRecognizer(endEditingGesture)
    }
    
}

// MARK: - 커스텀 메서드

extension AddContentViewController {
    
    @objc
    private func endEditingDidTap() {
        view.endEditing(true)
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
    }
    
}

// MARK: - UITextView 델리게이트

extension AddContentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = memoTextView.sizeThatFits(size)
        
        memoTextView.constraints.forEach { (constraint) in
            if estimatedSize.height >= memoTextViewMaxHeight {
                memoTextView.isScrollEnabled = true
            } else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        memoTextView.backgroundColor = .background
        memoTextView.layer.borderColor = UIColor.main.cgColor
        memoTextView.layer.borderWidth = CGFloat(2)
        memoTextView.layer.cornerRadius = CGFloat(5)
        memoTextView.layer.masksToBounds = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        memoTextView.backgroundColor = .subgray3
        memoTextView.layer.borderWidth = CGFloat(0)
        memoTextView.layer.borderColor = .none
    }
    
}
