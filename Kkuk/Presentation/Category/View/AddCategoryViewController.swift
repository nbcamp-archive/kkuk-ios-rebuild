//
//  AddCategoryViewController.swift
//  Kkuk
//
//  Created by 손영하 on 2023/10/19.
//

import SnapKit
import UIKit

class AddCategoryViewController: BaseUIViewController, UITextFieldDelegate {
    
    // MARK: - UI Components
    
    private lazy var titleInputLabel = createTitleInputLabel()
    private lazy var inputTextField = createInputTextField()
    private lazy var inputLimitLabel = createInputLimitLabel()
    private lazy var iconSelectionLabel = createIconSelectionLabel()
    private lazy var iconsGridStackView = createIconsGridStackView()
    private lazy var confirmButton = createConfirmButton()
    private var selectedIconButton: UIButton?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setupTapGesture()
    }
    
    // MARK: - UI Setup
    
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
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(16)
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(titleInputLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
        
        inputLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(4)
            make.trailing.equalTo(inputTextField)
        }
        
        iconSelectionLabel.snp.makeConstraints { make in
            make.top.equalTo(inputLimitLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        iconsGridStackView.snp.makeConstraints { make in
            make.top.equalTo(iconSelectionLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(iconsGridStackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Helper Functions for UI Components Creation
    
    private func createTitleInputLabel() -> UILabel {
        let label = UILabel()
        label.text = "카테고리 이름"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }
    
    private func createInputTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "카테고리 이름을 입력하세요."
        textField.backgroundColor = UIColor.subgray3
        textField.tintColor = UIColor.main
        textField.font = UIFont.body1
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.borderWidth = 1.0
        
        let paddingView = UIView()
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.addTarget(self, action: #selector(clearTextFieldContent), for: .touchUpInside)
        textField.rightView = clearButton
        textField.rightViewMode = .whileEditing
        
        return textField
    }
    
    private func createInputLimitLabel() -> UILabel {
        let label = UILabel()
        label.text = "*최대 15자까지 입력 가능"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.orange
        return label
    }
    
    private func createIconSelectionLabel() -> UILabel {
        let label = UILabel()
        label.text = "아이콘 선택"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }
    
    private func createIconsGridStackView() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        
        for _ in 0..<3 {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .fillEqually
            hStack.spacing = 10
            for _ in 0..<5 {
                let iconButton = UIButton()
                iconButton.setImage(UIImage(named: "blueCircle"), for: .normal)
                iconButton.layer.borderWidth = 2
                iconButton.layer.borderColor = UIColor.clear.cgColor
                iconButton.addTarget(self, action: #selector(iconButtonTapped), for: .touchUpInside)
                hStack.addArrangedSubview(iconButton)
            }
            stack.addArrangedSubview(hStack)
        }
        return stack
    }
    
    private func createConfirmButton() -> UIButton {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.backgroundColor = UIColor.main
        button.titleLabel?.font = UIFont.body2
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }
    
    // MARK: - Actions
    
    @objc func iconButtonTapped(_ sender: UIButton) {
        selectedIconButton?.layer.borderWidth = 0
        selectedIconButton?.layer.borderColor = UIColor.clear.cgColor
        
        sender.layer.cornerRadius = sender.frame.size.width / 2
        sender.layer.borderWidth = 3
        sender.layer.borderColor = UIColor.systemBlue.cgColor
        
        selectedIconButton = sender
    }
    
    @objc private func clearTextFieldContent() {
        inputTextField.text = ""
    }
    
    @objc func viewTapped() {
        print("Screen tapped!")
        view.endEditing(true)
    }
    
    @objc func confirmButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TextField Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputTextField {
            textField.backgroundColor = .white
            textField.borderStyle = .none
            textField.layer.cornerRadius = 5
            textField.layer.borderColor = UIColor.orange.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let markedTextRange = textField.markedTextRange,
           textField.position(from: markedTextRange.start, offset: 0) != nil {
            return true
        }
        
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        
        inputLimitLabel.text = "\(newLength)/15"
        
        return(newLength < 15)
    }
}
