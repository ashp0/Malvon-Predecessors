//
//  MATabItem.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-15.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Foundation

class MATabItem {
    var title: String
    var view: MAWebView
    var position: Int = 0
    var titleObserver: NSKeyValueObservation?
    
    init(title: String, view: MAWebView) {
        self.title = title
        self.view = view
        
        startObserving()
    }
    
    public func stopObserving() {
        titleObserver?.invalidate()
    }
    
    private func startObserving() {
        titleObserver = self.view.observe(\.title, changeHandler: { webView, value in
            Shared.Action.updateTabTitle(title: webView.title ?? "Untitled", position: self.position)
        })
    }
    
    
}
