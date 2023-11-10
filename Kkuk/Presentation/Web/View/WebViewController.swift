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
    
    let sourceURL: String?
    let sourceTitle: String?
    
    private lazy var backButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Asset.back.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
        buttonItem.tintColor = .selected
        return buttonItem
    }()
    
    private lazy var refreshButtonItem: UIBarButtonItem = {
        let buttonItem = UIBarButtonItem(image: Asset.refresh.withRenderingMode(.alwaysTemplate), style: .plain, target: nil, action: nil)
        buttonItem.tintColor = .selected
        return buttonItem
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.font = .title3
        label.textColor = .text1
        return label
    }()
    
    private lazy var wkWebView: WKWebView = {
        let view = WKWebView()
        view.allowsBackForwardNavigationGestures = true
        return view
    }()
    
    private lazy var wkWebViewToolbar = WebViewToolbar()
    
    init(sourceURL: String, sourceTitle: String) {
        self.sourceURL = sourceURL
        self.sourceTitle = sourceTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let url = URL(string: sourceURL ?? "") {
            let request = URLRequest(url: url)
            titleLabel.text = sourceTitle
            wkWebView.load(request)
        }
    }
    
    override func setNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.rightBarButtonItem = refreshButtonItem
    }
    
    override func setUI() {
        setNavigationBar()
        
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
    
    override func addTarget() {
        backButtonItem.target = self
        backButtonItem.action = #selector(backButtonItemDidTap(_:))
        
        refreshButtonItem.target = self
        refreshButtonItem.action = #selector(refreshButtonItemDidTap(_:))
        
        wkWebViewToolbar.backwardButton.target = self
        wkWebViewToolbar.forwardButton.target = self
        wkWebViewToolbar.shareButton.target = self
        wkWebViewToolbar.safariButton.target = self
        wkWebViewToolbar.backwardButton.action = #selector(backwardButtonDidTap(_:))
        wkWebViewToolbar.forwardButton.action = #selector(forwardButtonItemDidTap(_:))
        wkWebViewToolbar.shareButton.action = #selector(shareButtonItemDidTap(_:))
        wkWebViewToolbar.safariButton.action = #selector(safariButtonItemDidTap(_:))
        
    }
    
}

// MARK: - 커스텀 메서드

extension WebViewController {

    @objc
    private func backButtonItemDidTap(_ buttonItem: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @objc
    private func refreshButtonItemDidTap(_ buttonItem: UIBarButtonItem) {
        wkWebView.reload()
    }

    @objc
    private func backwardButtonDidTap(_ buttonItem: UIBarButtonItem) {
        if wkWebView.canGoBack {
            wkWebView.goBack()
        }
    }

    @objc
    private func forwardButtonItemDidTap(_ buttonItem: UITabBarItem) {
        if wkWebView.canGoForward {
            wkWebView.goForward()
        }
    }

    @objc
    private func shareButtonItemDidTap(_ buttonItem: UITabBarItem) {
        guard let url = wkWebView.url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }

    @objc
    private func safariButtonItemDidTap(_ buttonItem: UITabBarItem) {
        guard let url = wkWebView.url else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("해당 URL을 브라우저를 여는데 실패했습니다.")
        }
    }
    
}

// MARK: - WebKit UI 델리게이트

extension WebViewController: WKUIDelegate {

    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        showAlertOneButton(title: "", message: message, completion: {
            completionHandler()
        })
    }

    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        showAlertTwoButton(title: "", message: message, actionCompletion: {
            completionHandler(true)
        }, cancelCompletion: {
            completionHandler(false)
        })
    }

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

extension WebViewController: WKNavigationDelegate {}
