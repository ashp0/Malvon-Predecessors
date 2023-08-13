//
//  Shared.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-15.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa
import WebKit

class Shared {
    static let name = "Malvon"
    
    static var tabView: MATabView?
    static var webView: MAWebView?
    
    static var backwardButton: NSButton!
    static var forwardButton: NSButton!
    static var refreshButton: NSButton!
    
    static var tabs: [MATabItem] = []
    static var current = -1
    
    static func createWebView() -> MAWebView {
        let webView = MAWebView()
        webView.configure()
        
        return webView
    }
    
    static func createWebView(_ configuration: WKWebViewConfiguration) -> MAWebView {
        let webView = MAWebView(frame: .zero, configuration: configuration)
        webView.configure()
        
        return webView
    }
    
    
    static func checkWebViewButtons() {
        guard let webView = Shared.webView else {
            MAWindowController.tabBarViewController.refreshButton.isEnabled = false
            return
        }
        
        Shared.refreshButton.isEnabled = true
        
        Shared.backwardButton.isEnabled = webView.canGoBack
        Shared.forwardButton.isEnabled = webView.canGoForward
    }
    
    static func updateTabBar() {
        if Shared.Configuration.verticalTabBar {
            MAWindowController.tabBarViewController.update()
        } else {
            MAWindowController.viewController.tabBar.update()
        }
    }
}
