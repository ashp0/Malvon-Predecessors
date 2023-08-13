//
//  MAViewController+WebView.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-16.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa
import WebKit

extension MAViewController {
    func initializeWebView() {
        Shared.webView!.uiDelegate = self
        Shared.webView!.navigationDelegate = self
        
        Shared.webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        Shared.webView!.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }
    
    func deinitializeWebView(_ at: Int = Shared.current) {
        let current = Shared.tabs[at]
        
        current.view.removeObserver(self, forKeyPath: "estimatedProgress")
        current.view.removeObserver(self, forKeyPath: "URL")
        
        current.view.removeFromSuperview()
        current.stopObserving()
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            // TODO: Sometimes the progress bar doesn't hide
            guard let webView = Shared.webView else { return }
            progressBar.doubleValue = webView.estimatedProgress * 100
            
            if progressBar.maxValue <= (webView.estimatedProgress * 90) {
                progressBar.isHidden = true
                return
            }
        } else if keyPath == "URL" {
            // TODO: Implement a search bar
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressBar.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressBar.doubleValue = 0.00
        progressBar.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        Shared.checkWebViewButtons()
    }
}

extension MAViewController: WKUIDelegate, WKNavigationDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        let webView = Shared.Action.createNewTab(configuration: configuration)
        
        return webView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        Shared.Action.removeCurrentTab()
    }
}
