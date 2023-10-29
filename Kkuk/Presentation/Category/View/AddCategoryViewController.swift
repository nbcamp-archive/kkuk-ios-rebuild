//
//  AddCategoryViewController.swift
//  Kkuk
//
//  Created by 손영하 on 2023/10/19.
//

import SnapKit
import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func reloadCollectionView()
}

class AddCategoryViewController: UIViewController {
    weak var delegate: AddCategoryViewControllerDelegate?
    private let categoryTitleInputLabel = CategoryTitleInputLabel()
    private let categoryInputTextField = CategoryInputTextField()
    private let categoryInputLimitLabel = CategoryInputLimitLabel()
    private let categoryconfirmButton = ConfirmButton()
    private var iconButtons: [IconSelectButton] = []
    private let iconImageNames = ["plant", "education", "animal", "trip", "cafe"]
    private let categoryManager = RealmCategoryManager.shared
    private let category = Category()
    private var index: Int?
    
    var savedText: String? // 저장된 텍스트 변수
    var selectedIcon: UIImage? // 선택된 아이콘 변수
    var selectedIconButton: IconSelectButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        title = "카테고리"
        
        categoryInputTextField.delegate = self
        categoryInputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        categoryconfirmButton.addTarget(self, action: #selector(categoryconfirmButtonTapped), for: .touchUpInside)
        
        view.addSubview(categoryTitleInputLabel)
        view.addSubview(categoryInputTextField)
        view.addSubview(categoryInputLimitLabel)
        view.addSubview(categoryconfirmButton)
        
        iconImageNames.forEach { imageName in
            let button = IconSelectButton()
            let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            
            button.setImage(UIImage(named: imageName), for: .normal)
            button.addTarget(self, action: #selector(iconButtonTapped(_:)), for: .touchUpInside)
            iconButtons.append(button)
            view.addSubview(button)
        }
    }
    
    private func setupLayout() {
        categoryTitleInputLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        categoryInputTextField.snp.makeConstraints { make in
            make.top.equalTo(categoryTitleInputLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(40) // Adding height constraint
        }
        
        categoryInputLimitLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryInputTextField.snp.bottom).offset(5)
            make.trailing.equalTo(categoryInputTextField.snp.trailing)
        }
        
        let buttonsPerRow = 5
        for (index, button) in iconButtons.enumerated() {
            button.snp.makeConstraints { make in
                // 행과 열 계산
                let row = index / buttonsPerRow
                let col = index % buttonsPerRow
                
                if col == 0 {
                    make.leading.equalTo(view.snp.leading).offset(20) // 첫 번째 열
                } else {
                    make.leading.equalTo(iconButtons[index - 1].snp.trailing).offset(20) // 이전 버튼 오른쪽
                }
                
                if row == 0 {
                    make.top.equalTo(categoryInputLimitLabel.snp.bottom).offset(20) // 첫 번째 행
                } else {
                    make.top.equalTo(iconButtons[index - buttonsPerRow].snp.bottom).offset(20) // 이전 행 아래쪽
                }
                
                make.width.equalTo(52)
                make.height.equalTo(48)
            }
        }
        
        categoryconfirmButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX) // 가로 중앙
            make.centerY.equalTo(view.snp.centerY).offset(20) // 세로 중앙
            make.width.equalTo(categoryInputTextField.snp.width) // 기존의 너비 제약 조건
            make.height.equalTo(40) // 기존의 높이 제약 조건
        }
    }
    
    // IconSelectButton 인스턴스의 동작 처리
    @objc private func iconButtonTapped(_ sender: IconSelectButton) {
        // 기존 선택된 버튼의 오버레이 뷰 제거
        selectedIconButton?.subviews.forEach { if $0.tag == 999 { $0.removeFromSuperview() } }
        
        // 버튼의 이미지 뷰의 프레임을 사용하여 오버레이 뷰의 프레임 설정
        if let imageViewFrame = sender.imageView?.frame {
            let overlayView = UIView(frame: imageViewFrame)
            overlayView.backgroundColor = UIColor(white: 0.5, alpha: 0.5) // 원하는 색상으로 변경
            overlayView.tag = 999 // 오버레이 뷰 구분을 위한 태그 설정
            
            // 오버레이 뷰의 모서리를 둥글게 만들기
            overlayView.layer.cornerRadius = overlayView.frame.height / 2
            // 만약 버튼이 완벽한 원이면 이 값을 사용
            overlayView.clipsToBounds = true // 뷰의 경계 내부만 보이게 설정
            
            sender.addSubview(overlayView)
        }
        
        // 선택된 버튼 업데이트
        selectedIconButton = sender
        
        for (index, button) in iconButtons.enumerated() {
            if button == sender {
                self.index = index
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        categoryInputLimitLabel.text = "\(count)/20"
    }
    
    @objc private func categoryconfirmButtonTapped() {
        guard let categoryName = categoryInputTextField.text, !categoryName.isEmpty else {
            print("카테고리 이름을 입력해주세요") // 입력 필드가 비어 있을 경우 알림 또는 처리
            return
        }
        
        guard let iconIndex = index else {
            print("인덱스를 선택해주세요") // 입력 필드가 비어 있을 경우 알림 또는 처리
            return
        }
        
        // 카테고리 이름 저장
        savedText = categoryName
        category.name = savedText!
        index = iconIndex
        category.iconId = index!
        
        // UserDefaults를 사용하여 텍스트 필드에 입력된 카테고리 이름 저장
        categoryManager.write(category)
        
        // 선택된 아이콘 저장
        for button in iconButtons where button.isSelected {
            selectedIcon = button.imageView?.image
            break
        }
        
        // 화면 닫기
        delegate?.reloadCollectionView()
        dismiss(animated: true, completion: nil)
    }
}

extension AddCategoryViewController: UITextFieldDelegate {
    // 필요한 메소드들 구현
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == categoryInputTextField {
            textField.backgroundColor = .white
            textField.borderStyle = .none
            textField.layer.cornerRadius = 5 // 원하는 모서리 둥글기 값
            textField.layer.borderColor = UIColor.orange.cgColor
            textField.layer.borderWidth = 1.0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 조합 중인 문자열이 있는지 확인
        if let markedTextRange = textField.markedTextRange,
           textField.position(from: markedTextRange.start, offset: 0) != nil{
            return true
        }
        
        guard let currentText = textField.text else { return true }
        let newLength = currentText.count + string.count - range.length
        categoryInputLimitLabel.text = "\(newLength)/20"
        
        return newLength <= 20
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == categoryInputTextField {
            textField.backgroundColor = UIColor.subgray3
            textField.borderStyle = .none
            textField.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
