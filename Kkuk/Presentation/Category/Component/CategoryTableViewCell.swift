//
//  CategoryCollectionViewCell.swift
//  Kkuk
//
//  Created by 장가겸 on 10/23/23.
//

import RealmSwift
import SnapKit
import UIKit

extension UIImage {
    static func bringAsset(named name: String) -> UIImage {
        // 이미지를 찾을 수 없는 경우 이미지 또는 플레이스홀더를 반환합니다.
        return UIImage(named: name) ?? UIImage()
    }
}

enum IconAsset: Int {
    case trip = 0, cafe, education, animal, plant,
         book, kitchen, tech, finance, car,
         baby, interier, health, exercise, music,
         shopping, fashion, culture, beauty, food

    var image: UIImage? {
        switch self {
        case .trip: return .bringAsset(named: "trip")
        case .cafe: return .bringAsset(named: "cafe")
        case .education: return .bringAsset(named: "education")
        case .animal: return .bringAsset(named: "animal")
        case .plant: return .bringAsset(named: "plant")
        case .book: return .bringAsset(named: "book")
        case .food: return .bringAsset(named: "food")
        case .tech: return .bringAsset(named: "tech")
        case .finance: return .bringAsset(named: "finance")
        case .car: return .bringAsset(named: "car")
        case .baby: return .bringAsset(named: "baby")
        case .interier: return .bringAsset(named: "interier")
        case .health: return .bringAsset(named: "health")
        case .exercise: return .bringAsset(named: "exercise")
        case .music: return .bringAsset(named: "music")
        case .shopping: return .bringAsset(named: "shopping")
        case .kitchen: return .bringAsset(named: "kitchen")
        case .fashion: return .bringAsset(named: "fashion")
        case .culture: return .bringAsset(named: "culture")
        case .beauty: return .bringAsset(named: "beauty")
        }
    }
    
    static func image(for id: Int) -> UIImage? {
    return IconAsset(rawValue: id)?.image
    }
}

protocol CategoryTableViewCellDelegate: AnyObject {
    func deleteTableViewCell()
}

class CategoryTableViewCell: BaseUITableViewCell {
    private let categoryHelper = CategoryHelper.shared
    weak var delegate: CategoryTableViewCellDelegate?
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
        label.text = "레이블"
        label.textColor = .text1
        label.numberOfLines = 1
        label.font = .title3
        return label
    }()
    
    lazy var editCategoryButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(editCategoryButtonTapped), for: .touchUpInside)
        return button
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
        contentView.addSubviews([titleImage, titleLabel, editCategoryButton])
        contentView.backgroundColor = .clear
    }
    
    override func setLayout() {
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(4)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleImage.snp.trailing).offset(16)
            make.trailing.equalTo(editCategoryButton).inset(10)
            make.centerY.equalToSuperview()
        }
        
        editCategoryButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(6)
        }
    }
        func configure(category: Category) {
            self.category = category
            titleLabel.text = category.name
            setCategoryCell(id: category.iconId)
        }
        
        @objc func setCategoryCell(id: Int) {
            titleImage.image = IconAsset.image(for: id)
        }
        
        @objc func editCategoryButtonTapped() {
            _ = self.category
    }
}
