//
//  BaseUICollectionViewCell.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

class BaseUICollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // `BaseUICollectionViewCell`을 상속받은 객체는 해당 함수를 사용할 수 있습니다.
    //
    /// UI 구성을 위한 사용자 정의 함수입니다.
    func setUI() {}
    /// 화면 레이아웃을 설정하기 위한 사용자 정의 함수입니다.
    func setLayout() {}
    
}
