//
//  MATabViewConfiguration.swift
//  MATabView
//
//  Created by Ashwin Paudel on 2022-02-02.
//  Copyright © 2021-2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

public class MATabViewConfiguration: NSObject {
    // Light
    public var lightTabColor: NSColor = .white
    public var lightTabBorderColor: NSColor = .black
    public var lightTabBackgroundColor: NSColor = .white
    public var lightTabTitleTextColor: NSColor = .black
    
    // Dark
    public var darkTabColor: NSColor = .black
    public var darkTabBorderColor: NSColor = .lightGray
    public var darkTabBackgroundColor: NSColor = .black
    public var darkTabTitleTextColor: NSColor = .white
    
    // Tab Dimensions
    public var tabHeight: CGFloat = 30.0
    public var tabWidth: CGFloat = 225.0
    
    override public init() {}
}
