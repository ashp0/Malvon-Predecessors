//
//  MAViewController.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-14.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa
import WebKit

class MAViewController: NSViewController {
    
    @IBOutlet weak var tabBarStackView: NSStackView!
    @IBOutlet weak var tabBar: MATabBar!
    
    @IBOutlet weak var backwardButton: NSButton!
    @IBOutlet weak var forwardButton: NSButton!
    @IBOutlet weak var refreshButton: NSButton!
    
    
    @IBOutlet weak var webViewFrame: MATabView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureElements()
    }
    
    func configureElements() {
        if Shared.Configuration.verticalTabBar {
            tabBarStackView.isHidden = true
            tabBar.isHidden = true
        } else {
            tabBar.configure()
            Shared.backwardButton = backwardButton
            Shared.forwardButton = forwardButton
            Shared.refreshButton = refreshButton
        }
        
        Shared.tabView = webViewFrame
        progressBar.usesThreadedAnimation = true
    }
}
