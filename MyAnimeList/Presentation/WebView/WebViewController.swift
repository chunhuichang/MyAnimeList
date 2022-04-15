//
//  WebViewController.swift
//  MyAnimeList
//
//  Created by Jill Chang on 2022/4/11.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private var viewModel: WebViewModel
    
    private lazy var backButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.webGoBack))
    }()
    
    private lazy var nextButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "chevron.right"), style: .plain, target: self, action: #selector(self.webGoNext))
    }()
    
    private lazy var closeButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(self.closeVC))
    }()
    
    private lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let webview = WKWebView(frame: .zero, configuration: config)
        webview.navigationDelegate = self
        return webview
    }()
    
    private lazy var webLoadingActivity: UIActivityIndicatorView = {
        let webLoadingActivity = UIActivityIndicatorView()
        webLoadingActivity.hidesWhenStopped = true
        webLoadingActivity.style = .large
        return webLoadingActivity
    }()
    
    private lazy var webLoadingActivityContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.8
        view.layer.cornerRadius = 10
        return view
    }()
    
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        self.setupToolbarItemsEnable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.webView.stopLoading()
    }
}

// MARK: UI Setup
private extension WebViewController {
    private func setupUI() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "MAL"
        self.navigationItem.leftBarButtonItems = [backButton, nextButton]
        self.navigationItem.rightBarButtonItem = closeButton
        if let url = URL(string: self.viewModel.urlString) {
            self.webView.load(URLRequest(url: url))
        }
        
        view.addSubview(webView, anchors: [.leadingSafeArea(0), .trailingSafeArea(0),.topSafeArea(0),.bottomSafeArea(0)])
        view.addSubview(webLoadingActivity, anchors: [.centerX(0), .centerY(0)])
        view.addSubview(webLoadingActivityContainer, anchors: [.centerX(0), .centerY(0), .width(80), .height(80)])
    }
    
    private func setupToolbarItemsEnable() {
        backButton.isEnabled = self.webView.canGoBack
        nextButton.isEnabled = self.webView.canGoForward
    }
}

// MARK: Action
extension WebViewController {
    @objc final private func webGoBack() {
        guard self.webView.canGoBack else {
            return
        }
        self.webView.goBack()
    }
    
    @objc final private func webGoNext() {
        guard self.webView.canGoForward else {
            return
        }
        self.webView.goForward()
    }
    
    @objc final private func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    func showActivityIndicator(_ show: Bool) {
        if show {
            webLoadingActivity.startAnimating()
            webLoadingActivityContainer.isHidden = false
        } else {
            webLoadingActivity.stopAnimating()
            webLoadingActivityContainer.isHidden = true
        }
    }
    
    // navigation from the main frame has started.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        setupToolbarItemsEnable()
        showActivityIndicator(true)
    }
    
    // navigation is complete.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        setupToolbarItemsEnable()
        showActivityIndicator(false)
    }
    
    // error occurred during the early navigation process.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        setupToolbarItemsEnable()
        showActivityIndicator(false)
    }
    
    // error occurred during navigation.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        setupToolbarItemsEnable()
        showActivityIndicator(false)
    }
}
