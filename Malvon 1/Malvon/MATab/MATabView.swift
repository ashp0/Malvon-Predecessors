//
//  MATabView.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-15.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

class MATabView: NSView {
    func add(_ tab: MATabItem) {
        if !Shared.tabs.isEmpty {
            Shared.tabs[Shared.current].view.removeFromSuperview()
        }
        
        Shared.tabs.append(tab)
        Shared.current += 1
        tab.position = Shared.current
        self.switch(Shared.current)
        
        addWebView(tab)
        
        Shared.updateTabBar()
    }
    
    /// Note: Using this may cause the application to crash
    func fastSwitch(_ to: Int) {
        let tab = Shared.tabs[to]
        
        Shared.tabs[Shared.current].view.removeFromSuperview()
        Shared.current = to
        
        addWebView(tab)
        
        Shared.checkWebViewButtons()
    }
    
    func `switch`(_ to: Int) {
        if !Shared.tabs.isEmpty {
            let tab = Shared.tabs[to]
            
            Shared.tabs[Shared.current].view.removeFromSuperview()
            Shared.current = to
            
            addWebView(tab)
            
            Shared.checkWebViewButtons()
        }
    }
    
    func remove(_ at: Int) {
        // TODO: Make a better algorithm
        MAWindowController.viewController.deinitializeWebView(at)
        
        if Shared.tabs.count - 1 == 0 {
            Shared.current = -1
        } else if Shared.current == at {
            if (Shared.tabs.count - 1) != 0 || (Shared.tabs.count - 1) == 1 {
                if Shared.current == 0 {
                    Shared.current += 1
                } else {
                    Shared.current -= 1
                }
                self.switch(Shared.current)
            }
        } else {
            self.switch(Shared.current)
        }
        
        Shared.tabs.remove(at: at)
        
        for index in at ..< Shared.tabs.count {
            Shared.tabs[index].position = index
        }
        
        Shared.updateTabBar()
    }
    
    private func addWebView(_ tab: MATabItem) {
        tab.view.frame = bounds
        addSubview(tab.view)
        tab.view.autoresizingMask = [.height, .width]
        Shared.webView = tab.view
        
        MAWindowController.viewController.initializeWebView()
    }
}
