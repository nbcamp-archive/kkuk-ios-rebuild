//
//  AddCategoryViewController.swift
//  Kkuk
//
//  Created by 손영하 on 2023/10/19.
//

import SnapKit
import UIKit

protocol AddCategoryViewControllerDelegate: AnyObject {
    func reloadTableView()
}

class AddCategoryViewController: BaseUIViewController {
    weak var delegate: AddCategoryViewControllerDelegate?
    
    var savedText: String? // 저장된 텍스트 변수
    var selectedIcon: UIImage? // 선택된 아이콘 변수
    var selectedIconButton: IconSelectButton?
    
    private let categoryManager = RealmCategoryManager.shared
    private let category = Category()
    private let iconImageNames = ["plant", "education", "animal", "trip", "cafe"]
    private var index: Int?
    private var iconButtons: [IconSelectButton] = []
    
    private lazy var induceCategoryNameLabel = InduceLabel(text: "카테고리 이름 입력하기", font: .title2)
    
    private lazy var induceCategoryIconLabel = InduceLabel(text: "아이콘 선택하기", font: .title2)
    
    private lazy var addCategoryButton = AddContentButton(frame: .zero)
    
    private lazy var categoryNameLimitLabel: UILabel = {
        let label = UILabel()
        label.text = "0/20"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .subgray3
        textField.clearButtonMode = .whileEditing
        textField.font = .body1
        textField.placeholder = "카테고리 이름"
        textField.tintColor = .main
        return textField
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .close)
        barButtonItem.target = self
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryNameTextField.becomeFirstResponder()
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
        
        view.addSubviews([induceCategoryNameLabel, categoryNameTextField,
                          categoryNameLimitLabel, induceCategoryIconLabel, addCategoryButton])
        
        iconImageNames.forEach { imageName in
            let button = IconSelectButton()
            _ = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            
            button.setImage(UIImage(named: imageName), for: .normal)
            button.addTarget(self, action: #selector(iconButtonTapped(_:)), for: .touchUpInside)
            iconButtons.append(button)
            view.addSubview(button)
        }
    }
    
    override func setLayout() {
        induceCategoryNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(60)
            $0.leading.equalTo(view.snp.leading).offset(20)
        }
        categoryNameTextField.snp.makeConstraints {
            $0.top.equalTo(induceCategoryNameLabel.snp.bottom).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(48)
        }
        categoryNameLimitLabel.snp.makeConstraints {
            $0.top.equalTo(categoryNameTextField.snp.bottom).offset(5)
            $0.trailing.equalTo(categoryNameTextField.snp.trailing)
        }
        induceCategoryIconLabel.snp.makeConstraints {
            $0.top.equalTo(categoryNameLimitLabel.snp.bottom).offset(5)
            $0.leading.equalTo(induceCategoryNameLabel.snp.leading)
            $0.trailing.equalTo(categoryNameLimitLabel.snp.trailing)
        }
        
        let buttonsPerRow = 5
        for (index, button) in iconButtons.enumerated() {
            button.snp.makeConstraints {
                // 행과 열 계산
                let row = index / buttonsPerRow
                let col = index % buttonsPerRow
                
                if col == 0 {
                    $0.leading.equalTo(view.snp.leading).offset(30) // 첫 번째 열
                } else {
                    $0.leading.equalTo(iconButtons[index - 1].snp.trailing).offset(20) // 이전 버튼 오른쪽
                }
                
                if row == 0 {
                    $0.top.equalTo(induceCategoryIconLabel.snp.bottom).offset(20) // 첫 번째 행
                } else {
                    $0.top.equalTo(iconButtons[index - buttonsPerRow].snp.bottom).offset(20) // 이전 행 아래쪽
                }
                
                $0.width.equalTo(48)
                $0.height.equalTo(48)
            }
        }
        addCategoryButton.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(60)
        }
    }
    
    override func setNavigationBar() {
        title = "카테고리 추가"
        
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
    
    override func setDelegate() {
        categoryNameTextField.delegate = self
    }
    
    override func addTarget() {
        categoryNameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - 커스텀 메서드

extension AddCategoryViewController {
    // IconSelectButton 인스턴스의 동작 처리
    @objc
    private func iconButtonTapped(_ sender: IconSelectButton) {
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
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        let count = textField.text?.count ?? 0
        categoryNameLimitLabel.text = "\(count)/20"
    }
    
    @objc
    private func addCategoryButtonDidTap() {
        guard let text = categoryNameTextField.text, !text.isEmpty else {
            print("카테고리 이름을 입력해주세요") // 입력 필드가 비어 있을 경우 알림 또는 처리
            return
        }
        
        guard let iconIndex = index else {
            print("인덱스를 선택해주세요") // 입력 필드가 비어 있을 경우 알림 또는 처리
            return
        }
        
        // 카테고리 이름 저장
        savedText = text
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
        delegate?.reloadTableView()
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func closeButtonItemDidTap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = view.convert(keyboardFrame, from: nil).size.height
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.addCategoryButton.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc
    func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.addCategoryButton.transform = .identity
            self?.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - 텍스트필드 델리게이트

extension AddCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        categoryNameTextField.backgroundColor = .background
        categoryNameTextField.layer.borderWidth = CGFloat(2)
        categoryNameTextField.layer.cornerRadius = CGFloat(5)
        categoryNameTextField.layer.borderColor = UIColor.main.cgColor
        categoryNameTextField.layer.masksToBounds = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        categoryNameTextField.backgroundColor = .subgray3
        categoryNameTextField.layer.borderWidth = CGFloat(0)
        categoryNameTextField.layer.borderColor = .none
        addCategoryButton.updateButtonState(with: textField.text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 조합 중인 문자열이 있는지 확인
        if let markedTextRange = textField.markedTextRange, textField.position(from: markedTextRange.start, offset: 0) != nil {
            return true
        }
        
        guard let currentText = textField.text else { return true }
        
        let newLength = currentText.count + string.count - range.length
        
        categoryNameLimitLabel.text = "\(newLength)/20"
        
        return newLength <= 20
    }
}
