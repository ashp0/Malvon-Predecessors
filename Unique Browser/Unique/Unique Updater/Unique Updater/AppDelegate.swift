//
//  AppDelegate.swift
//  Unique Updater
//
//  Created by Ashwin Paudel on 2021-02-10.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

//    @IBOutlet var window: NSWindow!
var windowctr = UNUpdaterWindowController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        var psn = ProcessSerialNumber(highLongOfPSN: 1, lowLongOfPSN: UInt32(kCurrentProcess))
        TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        windowctr.showWindow(nil)
    }
    func applicationWillFinishLaunching(_ notification: Notification) {
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

