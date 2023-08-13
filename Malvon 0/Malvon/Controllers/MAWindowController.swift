//
//  MAWindowController.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2021-12-29.
//  Copyright © 2021-2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

class MAWindowController: NSWindowController, NSWindowDelegate {
    let properties = AppProperties()
    
    let windowState = "MAWindowControllerWindowState"
    fileprivate var leadingConstraint: NSLayoutConstraint?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        shouldCascadeWindows = false
        
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden
        
        self.contentViewController = MAViewController(windowCNTRL: self)
        self.window?.isMovableByWindowBackground = false
        
        
        let data = UserDefaults.standard.object(forKey: self.windowState) as? String ?? ""
        window?.setFrame(NSRectFromString(data), display: true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowWillClose), name: NSWindow.willCloseNotification, object: nil)
        
        relayoutTrafficLights(13)
    }
    
    convenience init() {
        self.init(windowNibName: "MAWindowController")
    }
    
    @IBAction func closeWindowController(_ sender: Any?) {
        self.close()
    }
    
    // MARK: - Position
    
    @objc func windowWillClose() {
        guard let frame = window?.frame else { return }
        UserDefaults.standard.set(NSStringFromRect(frame), forKey: self.windowState)
    }
    
    // MARK: - TitleBar
    
    // https://stackoverflow.com/questions/52150960/double-click-on-transparent-nswindow-title-does-not-maximize-the-window
    
    override func mouseUp(with event: NSEvent) {
        if event.clickCount >= 2, self.cursorIsOnTitlebar(event.locationInWindow) {
            self.window?.performZoom(nil)
        }
        super.mouseUp(with: event)
    }
    
    fileprivate func cursorIsOnTitlebar(_ point: CGPoint) -> Bool {
        if let windowFrame = self.window?.contentView?.frame {
            let titleBarRect = NSRect(x: self.window!.contentLayoutRect.origin.x, y: self.window!.contentLayoutRect.origin.y + self.window!.contentLayoutRect.height, width: self.window!.contentLayoutRect.width, height: windowFrame.height - self.window!.contentLayoutRect.height)
            return titleBarRect.contains(point)
        }
        return false
    }
    
    fileprivate func relayoutTrafficLights(_ offset: CGFloat) {
        let closeButton: NSButton = (window?.standardWindowButton(.closeButton))!
        let minButton = (window?.standardWindowButton(.miniaturizeButton))!
        let zoomButton = (window?.standardWindowButton(.zoomButton))!
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        zoomButton.translatesAutoresizingMaskIntoConstraints = false
        minButton.translatesAutoresizingMaskIntoConstraints = false
        
        let titlebarView = closeButton.superview
        titlebarView?.constraints.forEach { constraint in
            constraint.isActive = false
        }
        
        titlebarView?.addConstraints(
            [
                // Close Button
                NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: titlebarView, attribute: .top, multiplier: 1, constant: offset),
                NSLayoutConstraint(item: closeButton, attribute: .left, relatedBy: .equal, toItem: titlebarView, attribute: .left, multiplier: 1, constant: offset),
                
                // Minimize Button
                NSLayoutConstraint(item: minButton, attribute: .top, relatedBy: .equal, toItem: titlebarView, attribute: .top, multiplier: 1, constant: offset),
                NSLayoutConstraint(item: minButton, attribute: .left, relatedBy: .equal, toItem: titlebarView, attribute: .left, multiplier: 1, constant: offset + 18),
                
                // Zoom Button
                NSLayoutConstraint(item: zoomButton, attribute: .top, relatedBy: .equal, toItem: titlebarView, attribute: .top, multiplier: 1, constant: offset),
                NSLayoutConstraint(item: zoomButton, attribute: .left, relatedBy: .equal, toItem: titlebarView, attribute: .left, multiplier: 1, constant: offset + 36)
            ])
    }
    
    func windowWillEnterFullScreen(_ notification: Notification) {
        relayoutTrafficLights(7)
        
        window?.titleVisibility = .visible
        window?.titlebarAppearsTransparent = false
        window?.title = "Malvon"
        
        let vc = contentViewController as! MAViewController
        let controlStrip = vc.backForwardButtonStackView
        
        leadingConstraint = controlStrip?.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            controlStrip!.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 0),
            controlStrip!.widthAnchor.constraint(equalToConstant: 130),
            controlStrip!.heightAnchor.constraint(equalToConstant: 43),
            leadingConstraint!
        ])
    }
    
    func windowWillExitFullScreen(_ notification: Notification) {
        relayoutTrafficLights(13)
        window?.titleVisibility = .hidden
        window?.titlebarAppearsTransparent = true
        
        let vc = contentViewController as! MAViewController
        let controlStrip = vc.backForwardButtonStackView
        
        leadingConstraint?.isActive = false
        NSLayoutConstraint.activate([
            
            controlStrip!.topAnchor.constraint(equalTo: vc.view.topAnchor, constant: 0),
            controlStrip!.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor, constant: 60),
            controlStrip!.widthAnchor.constraint(equalToConstant: 130),
            controlStrip!.heightAnchor.constraint(equalToConstant: 43)
        ])
    }
}
