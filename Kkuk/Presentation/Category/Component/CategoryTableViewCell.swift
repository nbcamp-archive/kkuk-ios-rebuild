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

    var imageName: String {
        switch self {
        case .trip: return "trip"
        case .cafe: return "cafe"
        case .education: return "education"
        case .animal: return "animal"
        case .plant: return "plant"
        case .book: return "book"
        case .food: return "food"
        case .tech: return "tech"
        case .finance: return "finance"
        case .car: return "car"
        case .baby: return "baby"
        case .interier: return"interier"
        case .health: return "health"
        case .exercise: return "exercise"
        case .music: return "music"
        case .shopping: return "shopping"
        case .kitchen: return "kitchen"
        case .fashion: return "fashion"
        case .culture: return "culture"
        case .beauty: return "beauty"
        }
    }
    
    var image: UIImage? {
           return UIImage.bringAsset(named: imageName)
       }
       
       static func image(for id: Int) -> UIImage? {
           guard let item = IconAsset(rawValue: id) else { return nil }
           return item.image
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
        contentView.superview?.backgroundColor = .background
    }
    
    override func setLayout() {
        titleImage.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(4)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(45)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleImage.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
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
  
}
