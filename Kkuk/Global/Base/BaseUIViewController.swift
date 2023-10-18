//
//  BaseUIViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-15.
//

import UIKit

class BaseUIViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setUI()
        setLayout()
        setDelegate()
        addTarget()
    }
    // `BaseUIViewController`를 상속받은 객체는 해당 함수를 사용할 수 있습니다.
    //
    /// UI 구성을 위한 사용자 정의 함수입니다.
    func setUI() {}
    /// 화면 레이아웃을 설정하기 위한 사용자 정의 함수입니다.
    func setLayout() {}
    /// 델리게이트 설정을 위한 사용자 정의 함수입니다.
    func setDelegate() {}
    /// 타겟-액션 패턴을 지정하기 위한 사용자 정의 함수입니다.
    func addTarget() {}
    
}
