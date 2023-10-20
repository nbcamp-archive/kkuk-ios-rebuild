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
        
        // 화면 구성 요소의 레이아웃 설정
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
        
        // MARK: - Helper Functions for UI Components Creation
    
    // 카테고리 이름 라벨 설정
        private func createTitleInputLabel() -> UILabel {
        let label = UILabel()
        label.text = "카테고리 이름"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }
    
    // 사용자가 카테고리 이름을 입력할 텍스트 필드 설정
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
        textField.rightViewMode = .whileEditing
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
           label.font = UIFont.systemFont(ofSize: 12)
           label.textColor = .gray
           label.textAlignment = .right
           textField.rightView = label
        
        // 'x' 모양의 클리어 버튼 생성
        let clearButton = UIButton(type: .custom)
        clearButton.frame = CGRect(x: 0, y: 0, width: 65, height: 25) // 설정된 버튼의 크기
        clearButton.contentMode = .center

        // 'x' 이미지를 가진 이미지 뷰 생성
        let xmarkImage = UIImage(systemName: "xmark.circle.fill")
        let clearImageView = UIImageView(image: xmarkImage)

        // 버튼의 중앙에 위치하도록
        let imageViewYPosition = (clearButton.frame.height - 25) / 2
        clearImageView.frame = CGRect(x: 0, y: imageViewYPosition, width: 25, height: 25)

        // 이미지 뷰를 버튼에 추가
        clearButton.addSubview(clearImageView)

        // 버튼이 눌렸을 때의 동작 설정
        clearButton.addTarget(self, action: #selector(clearTextFieldContent), for: .touchUpInside)

        // 텍스트 필드의 오른쪽 뷰에 버튼을 설정
        textField.rightView = clearButton

        return textField
    }
    
    // 입력 글자 수 제한 안내 레이블 설정
        private func createInputLimitLabel() -> UILabel {
        let label = UILabel()
        label.text = "*최대 15자까지 입력 가능"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.orange
        return label
    }
    
    // 아이콘 선택을 위한 라벨 설정
        private func createIconSelectionLabel() -> UILabel {
        let label = UILabel()
        label.text = "아이콘 선택"
        label.font = UIFont.title2
        label.textColor = UIColor.text1
        return label
    }
    
    // 카테고리 아이콘들을 선택할 수 있는 그리드 뷰 설정
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
    
    // 카테고리 확인버튼 설정
        private func createConfirmButton() -> UIButton {
            let button = UIButton()
            button.setTitle("확인", for: .normal)
            button.backgroundColor = UIColor.main
            button.titleLabel?.font = UIFont.body2
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)  // 추가된 부분
            return button
        }

        // MARK: - Actions
        
        // 아이콘 버튼을 탭할 때의 동작
        @objc func iconButtonTapped(_ sender: UIButton) {
            
            // 이전에 선택된 아이콘 버튼의 선택을 해제
            selectedIconButton?.layer.borderWidth = 0
            selectedIconButton?.layer.borderColor = UIColor.clear.cgColor

            // 새로 선택된 아이콘 버튼 강조
            sender.layer.cornerRadius = sender.frame.size.width / 2  // 버튼을 동그랗게 만듭니다.
            sender.layer.borderWidth = 3
            sender.layer.borderColor = UIColor.systemBlue.cgColor

            // 선택된 아이콘 버튼 업데이트
            selectedIconButton = sender
        }
        
        // 텍스트 필드의 내용을 지우는 동작
        @objc private func clearTextFieldContent() {
            inputTextField.text = ""
        }
        
        // 화면을 탭할 때 키보드를 숨기고 화면을 원래대로 복구
        @objc func viewTapped() {
            print("Screen tapped!")  // 로깅 추가
            view.endEditing(true)
            
            func keyboardWillHide(notification: NSNotification) {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
        
        // 확인 버튼을 눌렀을 때의 동작
        @objc func confirmButtonTapped() {
                self.dismiss(animated: true, completion: nil)
            }
        
        // MARK: - TextField Delegate
        
    // 텍스트 필드 편집이 시작될 때 호출되는 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputTextField {
            textField.backgroundColor = .white
            textField.borderStyle = .none
            textField.layer.cornerRadius = 5 // 원하는 모서리 둥글기 값
            textField.layer.borderColor = UIColor.orange.cgColor
            textField.layer.borderWidth = 1.0
        }
    }

    // 텍스트 필드에서 텍스트 변경 시 글자수 제한과 관련된 동작
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
        
        inputLimitLabel.text = "\(newLength)/15"
        // 입력 제한 라벨 업데이트
        
        return (newLength < 15)
    }
    
    // 텍스트 필드 편집이 끝났을 때 호출되는 메서드
        func textFieldDidEndEditing(_ textField: UITextField) {
            if textField == inputTextField {
                textField.backgroundColor = UIColor.subgray3
                textField.borderStyle = .none
                textField.layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        // MARK: - Private Helpers

    // 사용자가 화면의 다른 부분을 탭하면 키보드를 숨김
        private func setupTapGesture() {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
                tapGesture.cancelsTouchesInView = true
                view.addGestureRecognizer(tapGesture)
            }
        }
