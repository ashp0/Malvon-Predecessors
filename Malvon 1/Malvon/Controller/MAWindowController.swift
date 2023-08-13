//
//  MAWindowController.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-14.
//

import Cocoa

class MAWindowController: NSWindowController {
    static let viewController = MAViewController()
    static let tabBarViewController = MATabBarViewController()
    
    lazy var contentSplitViewController: NSSplitViewController = {
        let splitViewController = NSSplitViewController()
        
        if Shared.Configuration.verticalTabBar {
            let sideBarSplitViewController = NSSplitViewItem(sidebarWithViewController: MAWindowController.tabBarViewController)
            sideBarSplitViewController.minimumThickness = 175.0
            splitViewController.addSplitViewItem(sideBarSplitViewController)
        }
        
        let contentViewController = NSSplitViewItem(viewController: MAWindowController.viewController)
        
        splitViewController.addSplitViewItem(contentViewController)
        
        return splitViewController
    }()
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.contentViewController = contentSplitViewController
    }
    
    convenience init() {
        self.init(windowNibName: "MAWindowController")
    }
    
}
