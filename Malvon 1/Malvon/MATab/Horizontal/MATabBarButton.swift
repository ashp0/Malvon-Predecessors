//
//  MATabBarButton.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-10-02.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

class MATabBarButton: NSButton {
    var tabBar: MATabBar?
    var isSelectedTab = false
    
    let tabTitle = NSTextField(frame: .zero)
    var closeButton = NSButton(frame: .zero)
    
    var xPosition: CGFloat = 4
    var yPosition: CGFloat = 2
    var closeButtonSize = NSSize(width: 16, height: 16)
    
    // MARK: - Initilizers
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        layer?.cornerRadius = 4
        layer?.borderWidth = 1
    }
    
    func configure() {
        // Tab Title
        
        let position = xPosition * 2 + closeButtonSize.width
        
        tabTitle.translatesAutoresizingMaskIntoConstraints = false
        tabTitle.isEditable = false
        tabTitle.alignment = .center
        tabTitle.isBordered = false
        tabTitle.drawsBackground = false
        addSubview(tabTitle)
        tabTitle.trailingAnchor
            .constraint(greaterThanOrEqualTo: trailingAnchor, constant: -position).isActive = true
        tabTitle.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: position).isActive = true
        tabTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        tabTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        tabTitle.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: yPosition).isActive = true
        tabTitle.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -yPosition).isActive = true
        tabTitle.setContentHuggingPriority(NSLayoutConstraint.Priority(rawValue: NSLayoutConstraint.Priority.defaultLow.rawValue - 10), for: .horizontal)
        tabTitle.setContentCompressionResistancePriority(NSLayoutConstraint.Priority.defaultLow, for: .horizontal)
        tabTitle.lineBreakMode = .byTruncatingTail
        
        // Close button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.target = self
        closeButton.action = #selector(closeTab)
        closeButton.heightAnchor.constraint(equalToConstant: closeButtonSize.height).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: closeButtonSize.width).isActive = true
        addSubview(closeButton)
        closeButton.trailingAnchor
            .constraint(greaterThanOrEqualTo: tabTitle.leadingAnchor, constant: -xPosition).isActive = true
        closeButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: yPosition).isActive = true
        closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: xPosition).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        closeButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -yPosition).isActive = true
        closeButton.bezelStyle = .shadowlessSquare
        closeButton.isBordered = false
        closeButton.imagePosition = .imageOnly
        closeButton.layer?.masksToBounds = false
        closeButton.wantsLayer = true
        
        tabTitle.stringValue = "saldkfmasdf" // TODO: saldkfmasdf
        let area = NSTrackingArea(rect: bounds, options: [.mouseMoved, .mouseEnteredAndExited, .activeAlways, .inVisibleRect, .enabledDuringMouseDrag], owner: self, userInfo: nil)
        addTrackingArea(area)
        
        // TODO: lsakdmflaskdfmasdf
        closeButton.image = NSImage(named: NSImage.quickLookTemplateName)
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        closeButton.image = NSImage(named: NSImage.stopProgressTemplateName)
        animator().alphaValue = 0.8
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        closeButton.animator().image = NSImage(named: NSImage.quickLookTemplateName)
        animator().alphaValue = isSelectedTab ? 1 : 0.6
    }
    
    @objc func closeTab() {
        print("Hello world")
    }
}
