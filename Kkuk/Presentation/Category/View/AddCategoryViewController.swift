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
    func dismissModal()
}

class AddCategoryViewController: BaseUIViewController {
    private var completion: ((Void) -> Void)?

    // MARK: - 변수
    let cellSpacing: CGFloat = 4
    
    var iconId: Int?
    
    var isAddCategory: Bool = true
    var modifyCategory: Category?
    
    weak var delegate: AddCategoryViewControllerDelegate?
    private var categoryHelper = CategoryHelper.shared
    
    // MARK: - 컴포넌트
    private lazy var induceCategoryNameLabel = InduceLabel(text: "카테고리 이름 입력하기", font: .title2)
    private lazy var induceCategoryIconLabel = InduceLabel(text: "아이콘 선택하기", font: .title2)
    private lazy var addCategoryButton = CompleteButton(frame: .zero)
    
    private lazy var categoryNameTextCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/20자"
        label.font = .body3
        label.textColor = .subgray1
        label.textAlignment = .right
        return label
    }()
    
    private lazy var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.configureCommonStyle()
        textField.placeholder = "카테고리 이름을 입력해주세요."
        return textField
    }()
    
    private lazy var closeButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(systemItem: .close)
        barButtonItem.target = self
        return barButtonItem
    }()
    
    private lazy var iconCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddCategoryIconCollectionViewCell.self,
                                forCellWithReuseIdentifier: "AddCategoryIconCollectionViewCell")
        collectionView.backgroundColor = .background
        
        return collectionView
    }()
    
    init(isAddCategory: Bool = true, modifyCategory: Category? = nil, completion: ((Void) -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.modifyCategory = modifyCategory
        self.isAddCategory = isAddCategory
        self.completion = completion
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !isAddCategory {
            configureForEditing()
        }
    }

    // MARK: - Setup
    override func setUI() {
        setNavigationBar()
        
        view.addSubviews([induceCategoryNameLabel,
                          categoryNameTextField,
                          categoryNameTextCountLabel,
                          induceCategoryIconLabel,
                          addCategoryButton,
                          iconCollectionView])
    }
    
    override func setLayout() {
        induceCategoryNameLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.leading.equalTo(20)
            $0.trailing.equalTo(-20)
        }
        
        categoryNameTextField.snp.makeConstraints {
            $0.top.equalTo(induceCategoryNameLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(induceCategoryNameLabel)
            $0.height.equalTo(48)
        }
        
        categoryNameTextCountLabel.snp.makeConstraints {
            $0.top.equalTo(categoryNameTextField.snp.bottom).offset(4)
            $0.trailing.equalTo(induceCategoryNameLabel)
        }
        
        induceCategoryIconLabel.snp.makeConstraints {
            $0.top.equalTo(categoryNameTextCountLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(induceCategoryNameLabel)
        }
        
        iconCollectionView.snp.makeConstraints { make in
            make.top.equalTo(induceCategoryIconLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        addCategoryButton.snp.makeConstraints {
            $0.top.equalTo(iconCollectionView.snp.bottom).offset(12)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8)
            $0.leading.trailing.equalTo(induceCategoryNameLabel)
            $0.height.equalTo(60)
        }
    }
    
    override func setNavigationBar() {
        title = isAddCategory ? "카테고리 추가" : "카테고리 수정"
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.title3 ]
        appearance.backgroundColor = .background
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
        addCategoryButton.addTarget(self, action: #selector(addCategoryButtonDidTap), for: .touchUpInside)
    }
}

// MARK: - 커스텀 메서드

extension AddCategoryViewController {
    
    private func updateAddCategoryButtonState() {
        guard let categoryName = categoryNameTextField.text, !categoryName.isEmpty,
              let seletedIconId = iconId, !seletedIconId.words.isEmpty else {
            addCategoryButton.setUI(to: .disable)
            return
        }
        addCategoryButton.setUI(to: .enable)
    }
    
    private func configureForEditing() {
        guard let modifyCategory = modifyCategory else { return }
        
        categoryNameTextField.text = modifyCategory.name
        
        for index in Asset.iconImageList.indices {
            if index == modifyCategory.iconId {
                let indexPath = IndexPath(item: index, section: 0)
                iconCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
            } else {
                let indexPath = IndexPath(item: index, section: 0)
                iconCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
        
        addCategoryButton.setUI(to: .enable)
    }
    
    private func addCategory() {
        guard let categoryName = categoryNameTextField.text, let selectedIconId = iconId  else { return }
        
        let category = Category()
        category.name = categoryName
        category.iconId = selectedIconId

        categoryHelper.write(category)
    }
    
    private func updateCategory() {
        guard let categoryName = categoryNameTextField.text,
              let selectedIconId = iconId,
              let modifyCategory = modifyCategory else { return }
        
        categoryHelper.update(modifyCategory, completion: { modifyCategory in
            modifyCategory.name = categoryName
            modifyCategory.iconId = selectedIconId
        })
    }
    
    private func dismissPanModal() {
        if let presentingViewController = self.presentingViewController as? PanModalTableViewController {
            presentingViewController.dismiss(animated: false)
        }
    }
}

// MARK: - @objc

extension AddCategoryViewController {
    @objc private func addCategoryButtonDidTap() {

        if isAddCategory {
            addCategory()
        } else {
            updateCategory()
        }
        
        let title = isAddCategory ? "추가" : "수정"
        
        showAlertOneButton(title: "", message: "카테고리가 정상적으로 \(title) 되었습니다.", completion: {
            self.dismiss(animated: true, completion: nil)
            self.delegate?.dismissModal()
        })
    }
    
    @objc func closeButtonItemDidTap() {
        self.dismiss(animated: true, completion: nil)
        self.dismissPanModal()
    }
}
// MARK: - 텍스트필드 델리게이트
extension AddCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateAddCategoryButtonState()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.configureForEditing()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.configureCommonStyle()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let markedTextRange = textField.markedTextRange, textField.position(from: markedTextRange.start, offset: 0) != nil {
            return true
        }
        
        guard let currentText = textField.text else { return true }
        
        let newLength = currentText.count + string.count - range.length
        
        categoryNameTextCountLabel.text = "\(newLength)/20자"
        
        return newLength < 20
    }
}

// MARK: - 콜렉션뷰 델리게이트
extension AddCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Asset.iconImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "AddCategoryIconCollectionViewCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellName,
                                                         for: indexPath) as? AddCategoryIconCollectionViewCell {
            cell.configuration(index: indexPath.row)
            return cell
        }
        
        return BaseUICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width / 5) - (cellSpacing * 4)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AddCategoryIconCollectionViewCell {
            cell.isSelected = true
            iconId = indexPath.row
            updateAddCategoryButtonState()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AddCategoryIconCollectionViewCell {
            cell.isSelected = false
        }
    }
}
