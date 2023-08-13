//
//  Actions.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-16.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Foundation
import WebKit

extension Shared {
    class Action {
        static func createNewTab() {
            let newWebView = Shared.createWebView()
            
            //            newWebView.load(URLRequest(url: URL(string: "https://www.google.com")!))
            
            let URL = Bundle.main.url(forResource: "newtab", withExtension: "html")
            newWebView.loadFileURL(URL!, allowingReadAccessTo: URL!)
            
            let tab = MATabItem(title: "New Tab", view: newWebView)
            
            Shared.tabView!.add(tab)
        }
        
        static func createNewTab(configuration: WKWebViewConfiguration) -> MAWebView {
            let newWebView = Shared.createWebView(configuration)
            
            let tab = MATabItem(title: "New Tab", view: newWebView)
            
            Shared.tabView!.add(tab)
            
            return newWebView
        }
        
        static func removeCurrentTab() {
            Shared.tabView!.remove(Shared.current)
        }
        
        static func updateTabTitle(title: String, position: Int) {
            Shared.tabs[position].title = title
            
            Shared.updateTabBar()
        }
        
        static func switchTab(_ at: Int) {
            if at > (Shared.tabs.count - 1) {
                return
            }
            
            Shared.updateTabBar()
            
            Shared.tabView!.fastSwitch(at)
        }
        
        static func closeTab(_ at: Int) {
            Shared.tabView!.remove(at)
        }
        
        static func reloadWebView() {
            Shared.webView!.reload()
        }
        
        static func backWebView() {
            if Shared.webView!.canGoBack {
                Shared.webView!.goBack()
            }
        }
        
        static func forwardWebView() {
            if Shared.webView!.canGoForward {
                Shared.webView!.goForward()
            }
        }
    }
}
