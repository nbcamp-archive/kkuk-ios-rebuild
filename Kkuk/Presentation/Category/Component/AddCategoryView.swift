//
//  AddCategoryView.swift
//  Kkuk
//
//  Created by 손영하  on 2023/10/24.
//

import UIKit

class AddCategoryView: UIView, UITextFieldDelegate {
    
    // MARK: - UI Components
    
    private lazy var titleInputLabel = createTitleInputLabel()
    private lazy var inputTextField = createInputTextField()
    private lazy var inputLimitLabel = createInputLimitLabel()
    private lazy var iconSelectionLabel = createIconSelectionLabel()
    private lazy var iconsGridStackView = createIconsGridStackView()
    private lazy var confirmButton = createConfirmButton()
    private var selectedIconButton: UIButton?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupTapGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupTapGesture()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubviews([
            titleInputLabel,
            inputTextField,
            inputLimitLabel,
            iconSelectionLabel,
            iconsGridStackView,
            confirmButton
        ])
        setLayout()
    }
    
   private func setLayout() {
       titleInputLabel.translatesAutoresizingMaskIntoConstraints = false
       inputTextField.translatesAutoresizingMaskIntoConstraints = false
       inputLimitLabel.translatesAutoresizingMaskIntoConstraints = false
       iconSelectionLabel.translatesAutoresizingMaskIntoConstraints = false
       iconsGridStackView.translatesAutoresizingMaskIntoConstraints = false
       confirmButton.translatesAutoresizingMaskIntoConstraints = false

       NSLayoutConstraint.activate([
           titleInputLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
           titleInputLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

           inputTextField.topAnchor.constraint(equalTo: titleInputLabel.bottomAnchor, constant: 16),
           inputTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor),
           inputTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
           inputTextField.heightAnchor.constraint(equalToConstant: 48),

           inputLimitLabel.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 4),
           inputLimitLabel.trailingAnchor.constraint(equalTo: inputTextField.trailingAnchor),

           iconSelectionLabel.topAnchor.constraint(equalTo: inputLimitLabel.bottomAnchor, constant: 16),
           iconSelectionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

           iconsGridStackView.topAnchor.constraint(equalTo: iconSelectionLabel.bottomAnchor, constant: 16),
           iconsGridStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
           iconsGridStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
           iconsGridStackView.heightAnchor.constraint(equalToConstant: 200),

           confirmButton.topAnchor.constraint(equalTo: iconsGridStackView.bottomAnchor, constant: 16),
           confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
           confirmButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9),
           confirmButton.heightAnchor.constraint(equalToConstant: 48)
       ])
   }

    private func setupTapGesture() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
            self.addGestureRecognizer(tapGesture)
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
        // 아이콘 이미지 이름들을 배열로 정의합니다.
        let iconImageNames = ["trip", "education", "plant", "animal", "cafe"]
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10

        var imageIndex = 0  // 아이콘 이미지 이름 배열의 인덱스를 나타내는 변수
        for _ in 0..<3 {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.distribution = .fillEqually
            hStack.spacing = 10
            
            for _ in 0..<5 {
                let iconButton = UIButton()
                
                // 배열에서 이미지 이름을 가져와 이미지를 설정
                if imageIndex < iconImageNames.count {
                    iconButton.setImage(UIImage(named: iconImageNames[imageIndex]), for: .normal)
                    imageIndex += 1
                }
                
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
        self.endEditing(true)
    }
    
    // 확인 버튼을 눌렀을 때의 동작
    @objc func confirmButtonTapped() {
        }
}
