//
//  CustomCategoryViewController.swift
//  Kkuk
//
//  Created by 손영하 on 2023/10/19.
//

import SnapKit
import UIKit

class CustomCategoryViewController: BaseUIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        
        // 키보드가 화면을 가릴 때 조정을 위한 옵저버 등록
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        // 화면 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private lazy var titleInputLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리 이름"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "카테고리 이름을 입력하세요"
        textField.backgroundColor = UIColor.subgray3
        textField.tintColor = UIColor.main
        textField.font = UIFont.body1
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        return textField
    }()
    
    private lazy var inputLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "*최대 15자 까지 입력 가능"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .red
        return label
    }()
    
    private lazy var iconSelectionLabel: UILabel = {
        let label = UILabel()
        label.text = "아이콘 선택"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }()
    
    private lazy var iconsGridStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        for _ in 0..<3 {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .fillEqually
            hStack.spacing = 10
            for _ in 0..<3 {
                let iconButton = UIButton()
                iconButton.setImage(UIImage(named: "yourIconName"), for: .normal)
                hStack.addArrangedSubview(iconButton)
            }
            stack.addArrangedSubview(hStack)
        }
        return stack
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.main
        button.titleLabel?.font = UIFont.body2
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func setUI() {
        view.addSubviews([
            titleInputLabel,
            inputTextField,
            inputLimitLabel,
            iconSelectionLabel,
            iconsGridStackView,
            confirmButton
        ])
    }
    
    override func setLayout() {
        titleInputLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(titleInputLabel.snp.bottom).offset(14)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(48)
        }
        
        inputLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(4)
            make.centerX.equalTo(view)
        }
        
        iconSelectionLabel.snp.makeConstraints { make in
            make.top.equalTo(inputLimitLabel.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
        
        iconsGridStackView.snp.makeConstraints { make in
            make.top.equalTo(iconSelectionLabel.snp.bottom).offset(14)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(iconsGridStackView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(50)
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 15
    }
    
    // 화면 탭 시 키보드를 내리는 함수
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(
        
        notification: NSNotification) {
            if let keyInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardSize = keyInfo.cgRectValue
                if view.frame.origin.y == 0 {
                    view.frame.origin.y -= keyboardSize.height / 2
                }
            }
        }
    
    @objc func keyboardWillHide(
        notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }

    deinit {
        // 옵저버 해제
        NotificationCenter.default.removeObserver(self)
    }
}
