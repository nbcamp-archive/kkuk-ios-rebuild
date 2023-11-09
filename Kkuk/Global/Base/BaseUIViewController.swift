//
//  BaseUIViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-15.
//

import IQKeyboardManagerSwift
import UIKit

class BaseUIViewController: UIViewController {
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .main
        return view
    }()
    
    lazy var topTitle: UILabel = {
        let label = UILabel()
        label.font = .title1
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background
        
        setTopView()
        setUI()
        setLayout()
        setDelegate()
        addTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        setIQKeyboardManagerEnable(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        setIQKeyboardManagerEnable(false)
    }
    
    // `BaseUIViewController`를 상속받은 객체는 해당 함수를 사용할 수 있습니다.
    /// TopView를 추가하는 함수입니다.
    func setTopView() {}
    /// 네비게이션 바 구성을 위한 사용자 정의 함수 입니다.
    func setNavigationBar() {}
    /// UI 구성을 위한 사용자 정의 함수입니다.
    func setUI() {}
    /// 화면 레이아웃을 설정하기 위한 사용자 정의 함수입니다.
    func setLayout() {}
    /// 델리게이트 설정을 위한 사용자 정의 함수입니다.
    func setDelegate() {}
    /// 타겟-액션 패턴을 지정하기 위한 사용자 정의 함수입니다.
    func addTarget() {}
    
}

// MARK: - IQKeyboardManagerSwift 활성화 메서드

extension BaseUIViewController {
    
//    func setIQKeyboardManagerEnable(_ enabled: Bool) {
//        IQKeyboardManager.shared.enable = enabled
//        IQKeyboardManager.shared.shouldResignOnTouchOutside = enabled
//        IQKeyboardManager.shared.enableAutoToolbar = !enabled
//    }
    
}

extension BaseUIViewController {
    func showAlert(title: String?, message: String?, actionTitle: String = "확인", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let action = UIAlertAction(title: actionTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
