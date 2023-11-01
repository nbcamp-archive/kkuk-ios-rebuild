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

class CategoryCollectionViewCell: BaseUITableViewCell {
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
        label.textColor = .text1
        label.numberOfLines = 1
        label.font = .title3
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI() {
        contentView.addSubviews([titleImage, titleLabel])
        contentView.backgroundColor = .clear
    }
    
    override func setLayout() {
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleImage.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(category: Category) {
        self.category = category
        titleLabel.text = category.name
        setCategoryCell(id: category.iconId)
    }
    
    @objc func setCategoryCell(id: Int) {
        switch id {
        case 0:
            titleImage.image = UIImage(named: "plant")
        case 1:
            titleImage.image = UIImage(named: "education")
        case 2:
            titleImage.image = UIImage(named: "animal")
        case 3:
            titleImage.image = UIImage(named: "trip")
        case 4:
            titleImage.image = UIImage(named: "cafe")
        default:
            return
        }
    }
}
