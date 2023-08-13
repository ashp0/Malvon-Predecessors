//
//  AppDelegate.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-14.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let windowController = MAWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        windowController.showWindow(nil)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    @IBAction func createNewTab(_ sender: Any) {
        Shared.Action.createNewTab()
    }
    
    @IBAction func createNewWindow(_ sender: Any) {
        // TODO: Find a way so that Shared. only applies to one window
        // Maybe have each property has their own instance to their own window
        //        let newWindowController = MAWindowController(windowNibName: "MAWindowController")
        //        newWindowController.showWindow(nil)
        Shared.Action.createNewTab()
    }
    
    // TODO: Needs implementation
    //    @IBAction func openFile(_ sender: Any) {
    //        Shared.Action.createNewTab()
    //    }
    
    @IBAction func closeTab(_ sender: Any) {
        Shared.Action.closeTab(Shared.current)
    }
    
    @IBAction func closeWindow(_ sender: Any) {
        NSApplication.shared.keyWindow?.close()
    }
    
    @IBAction func reloadWebView(_ sender: Any) {
        Shared.Action.reloadWebView()
    }
    
    @IBAction func forwardWebView(_ sender: Any) {
        Shared.Action.forwardWebView()
    }
    
    @IBAction func backWebView(_ sender: Any) {
        Shared.Action.backWebView()
    }
    
    // Switch the tab using a keyboard shortcut CMD(1,2,3,4,5,6,7,8,9)
    @IBAction func switchTabKeyboard1(_ sender: Any) {
        print("Hello world")
        Shared.Action.switchTab(0)
    }
    
    @IBAction func switchTabKeyboard2(_ sender: Any) {
        Shared.Action.switchTab(1)
    }
    
    @IBAction func switchTabKeyboard3(_ sender: Any) {
        Shared.Action.switchTab(2)
    }
    
    @IBAction func switchTabKeyboard4(_ sender: Any) {
        Shared.Action.switchTab(3)
    }
    
    @IBAction func switchTabKeyboard5(_ sender: Any) {
        Shared.Action.switchTab(4)
    }
    
    @IBAction func switchTabKeyboard6(_ sender: Any) {
        Shared.Action.switchTab(5)
    }
    
    @IBAction func switchTabKeyboard7(_ sender: Any) {
        Shared.Action.switchTab(6)
    }
    
    @IBAction func switchTabKeyboard8(_ sender: Any) {
        Shared.Action.switchTab(7)
    }
    
    @IBAction func switchTabKeyboard9(_ sender: Any) {
        Shared.Action.switchTab(Shared.tabs.count - 1)
    }
}

