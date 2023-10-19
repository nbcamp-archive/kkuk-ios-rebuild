//
//  AddCategoryViewController.swift
//  Kkuk
//
//  Created by 손영하 on 2023/10/19.
//

import SnapKit
import UIKit

class AddCategoryViewController: BaseUIViewController, UITextFieldDelegate {
    
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
        
        inputTextField.becomeFirstResponder()
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20) // 상단 safeArea로부터 20픽셀 아래에 위치
            make.leading.equalTo(view).offset(16) // 화면의 왼쪽 가장자리로부터 16픽셀 떨어져서 위치
        }
        
        inputTextField.snp.makeConstraints { make in
            make.top.equalTo(titleInputLabel.snp.bottom).offset(16) // 16픽셀 간격
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(48)
        }
        
        inputLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(inputTextField.snp.bottom).offset(4) // 4픽셀 간격
            make.trailing.equalTo(inputTextField) // inputTextField의 오른쪽 끝에 맞춤
        }
        
        iconSelectionLabel.snp.makeConstraints { make in
            make.top.equalTo(inputLimitLabel.snp.bottom).offset(16) // 16픽셀 간격
            make.leading.equalTo(view).offset(16)
        }
        
        iconsGridStackView.snp.makeConstraints { make in
            make.top.equalTo(iconSelectionLabel.snp.bottom).offset(16) // 16픽셀 간격
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(iconsGridStackView.snp.bottom).offset(16) // 16픽셀 간격
            make.centerX.equalTo(view)
            make.width.equalTo(view).multipliedBy(0.9)
            make.height.equalTo(48)
        }
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        // 현재 조합 중인 문자열이 있는지 확인
        if let markedTextRange = textField.markedTextRange,
           textField.position(from: markedTextRange.start, offset: 0) != nil {
            return true
        }
        
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        return newLength <= 15
    }
    
    // 화면 탭 시 키보드를 내리는 함수
    @objc func viewTapped() {
        print("Screen tapped!")  // 로깅 추가
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = keyInfo.cgRectValue
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            
            // inputTextField가 키보드에 의해 가려진 경우 화면을 위로 올려줍니다.
            let rect = self.view.frame
            if rect.origin.y + inputTextField.frame.maxY > self.view.frame.height - keyboardSize.height {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // 화면을 원래 위치로 되돌립니다.
        self.view.frame.origin.y = 0
        
    }
}
