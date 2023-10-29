//
//  CategoryCollectionViewCell.swift
//  Kkuk
//
//  Created by 장가겸 on 10/23/23.
//

import RealmSwift
import SnapKit
import UIKit

protocol CategoryCollectionViewCellDelegate: AnyObject {
    func deleteCollectionViewCell()
}

class CategoryCollectionViewCell: UICollectionViewCell {
    private let categoryManager = RealmCategoryManager.shared
    weak var delegate: CategoryCollectionViewCellDelegate?
    private var category: Category?
    private var id: Int?
    
    private let textSizeOfheightSize: CGFloat = {
        switch UIScreen.main.bounds.width {
        case 400...:
            return 37
        case 380...:
            return 33
        case 370...:
            return 20
        default:
            return 30
        }
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(titleLabel)
        return stackView
    }()
    
    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "plus")
        imageView.tintColor = .background
        imageView.image = image
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "조제 호랑이 그리고 물고기들과 상어 장어 거북이"
        label.textColor = .background
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .title3
        return label
    }()
    
    private lazy var deleteModifyButton: UIButton = {
        let button = UIButton()
        let modify = UIAction(title: "수정하기", handler: { _ in print("수정하기") })
        let delete = UIAction(title: "삭제하기", handler: { [self] _ in categoryManager.delete(category!)
            self.delegate?.deleteCollectionViewCell()
        })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in })
        button.setTitle(":", for: .normal)
        button.tintColor = UIColor(red: 0.60, green: 0.60, blue: 0.60, alpha: 0.33)
        button.menu = UIMenu(title: "", identifier: nil, options: .displayInline, children: [modify, delete, cancel])
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    func setUp() {
        contentView.addSubviews([titleImage, stackView, deleteModifyButton])
        contentView.backgroundColor = .systemGray
        
        contentView.layer.shadowColor = UIColor.black.cgColor // 색깔
        contentView.layer.masksToBounds = false // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        contentView.layer.shadowRadius = 5 // 반경
        contentView.layer.shadowOpacity = 0.3 // alpha값
        
        deleteModifyButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.trailing.equalToSuperview().offset(-2)
        }
        
        titleImage.snp.makeConstraints { make in
            make.top.equalTo(deleteModifyButton.snp.bottom)
            make.width.equalTo(contentView.bounds.width / 3)
            make.height.equalTo(contentView.bounds.width / 3)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleImage.snp.bottom).offset(textSizeOfheightSize)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }

        titleImage.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleImage.setContentHuggingPriority(.defaultLow, for: .vertical)

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderWidth = 0.1
        contentView.layer.borderColor = UIColor.subgray1.cgColor
    }
    
    func configure(category: Category) {
        self.category = category
        titleLabel.text = category.name
        setCategoryCell(id: category.iconId)
    }
    
    @objc func setCategoryCell(id: Int) {
        switch id {
        case 0:
            contentView.backgroundColor = UIColor(red: 0.00, green: 0.74, blue: 0.61, alpha: 1.00)
            titleImage.image = UIImage(named: "plant")
        case 1:
            contentView.backgroundColor = UIColor(red: 0.00, green: 0.30, blue: 0.45, alpha: 1.00)
            titleImage.image = UIImage(named: "education")
        case 2:
            contentView.backgroundColor = UIColor(red: 0.71, green: 0.34, blue: 0.58, alpha: 1.00)
            titleImage.image = UIImage(named: "animal")
        case 3:
            contentView.backgroundColor = UIColor(red: 0.00, green: 0.48, blue: 0.86, alpha: 1.00)
            titleImage.image = UIImage(named: "trip")
        case 4:
            contentView.backgroundColor = UIColor(red: 0.75, green: 0.65, blue: 0.62, alpha: 1.00)
            titleImage.image = UIImage(named: "cafe")
        default:
            return
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
