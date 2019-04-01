//
//  NewsWebViewerViewController.swift
//  Hacker-news
//
//  Created by Prerna Kumari on 01/04/19.
//  Copyright © 2019 Prerna Kumari. All rights reserved.
//

import UIKit
import WebKit

class NewsWebViewerViewController: UIViewController, WKUIDelegate {

    private static let estimatedKeyPath = "estimatedProgress"

    private lazy var progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .bar)
        view.trackTintColor = UIColor.lightGray.withAlphaComponent(0.5)
        view.tintColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let urlString: String
    
    private var webView: WKWebView!
    
    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: "NewsWebViewerViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        webView.removeObserver(self, forKeyPath: NewsWebViewerViewController.estimatedKeyPath)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.addObserver(
            self,
            forKeyPath: NewsWebViewerViewController.estimatedKeyPath,
            options: .new,
            context: nil)
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupProgressView()

        guard let urlToLoad = URL(string: urlString) else {
            print("No URL")
            return
        }
        let request = URLRequest(url: urlToLoad)
        webView.load(request)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == NewsWebViewerViewController.estimatedKeyPath {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }

    private func setupNavBar() {
        navigationController?.navigationBar.isTranslucent = false
        title = urlString
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeTapped))
    }

    private func setupProgressView() {
        view.addSubview(progressView)
        let heightConstraint = NSLayoutConstraint(
            item: progressView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 2.0)
        let widthContraint = NSLayoutConstraint(
            item: progressView,
            attribute: .width,
            relatedBy: .equal,
            toItem: view,
            attribute: .width,
            multiplier: 1,
            constant: 0)
        let topConstraint = NSLayoutConstraint(
            item: progressView,
            attribute: .top,
            relatedBy: .equal,
            toItem: view,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        NSLayoutConstraint.activate([heightConstraint, widthContraint, topConstraint])
    }
    
    @objc
    private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func showProgressView() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 1
        }
    }

    private func hideProgressView() {
        UIView.animate(withDuration: 0.5) {
            self.progressView.alpha = 0
        }
    }
}

extension NewsWebViewerViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
