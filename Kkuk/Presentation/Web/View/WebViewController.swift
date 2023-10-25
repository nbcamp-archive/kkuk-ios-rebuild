//
//  WebViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-25.
//

import SnapKit
import UIKit
import WebKit

class WebViewController: BaseUIViewController {
    
    private lazy var wkWebViewToolbar = WebViewToolbar()
    
    private lazy var wkWebView: WKWebView = {
        let view = WKWebView()
        view.frame = .zero
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    override func setUI() {
        view.addSubviews([wkWebViewToolbar, wkWebView])
    }
    
    override func setLayout() {
        wkWebViewToolbar.snp.makeConstraints { constraint in
            constraint.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        wkWebView.snp.makeConstraints { constraint in
            constraint.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            constraint.bottom.equalTo(wkWebViewToolbar.snp.top)
        }
    }
    
    override func setDelegate() {
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self
    }
    
}

// MARK: - WebKit UI 델리게이트

extension WebViewController: WKUIDelegate {
    // JavaScript alert 패널 처리
    //
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
            completionHandler()
        })
        
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    // JavaScript confirm 패널 처리
    //
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            completionHandler(true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            completionHandler(false)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    // JavaScript 텍스트인풋 패널 처리
    //
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
                 defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: "", message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }
        
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let text = alertController.textFields?.first?.text {
                completionHandler(text)
            } else {
                completionHandler(defaultText)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
            completionHandler(nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - WebKit 네비게이션 델리게이트

extension WebViewController: WKNavigationDelegate {
    
}
