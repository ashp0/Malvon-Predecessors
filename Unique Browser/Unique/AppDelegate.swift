//
//  AppDelegate.swift
//  Unique
//
//  Created by Ashwin Paudel on 2020-02-05.
//

import Cocoa
import UserNotifications
import CrashReporter
import APUpdater

let crashReporterURL = URL(string: "http://127.0.0.1:3333/")!

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {

    var tabService: TabService!
    let mywindowController = WindowController()
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.banner)
        }
    func applicationWillFinishLaunching(_ notification: Notification) {
//        updateApp()
//        UNUpdateUtilities.download()
        APUpdater(downloadURL: URL(string: "https://github.com/Ashwin-Paudel/download/raw/main/Unique.zip")!, newVersionText: URL(string: "https://raw.githubusercontent.com/Ashwin-Paudel/download/main/asdfsadf.txt")!, updateInfo: URL(string: "https://raw.githubusercontent.com/Ashwin-Paudel/download/main/tex.txt")!, appName: "Unique").checkForUpdates()
            
        
        
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
    }
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.prohibited)
    }
    @IBAction func updateUnique(_ sender: Any?) {
        UNUpdateUtilities.download()
    }
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        return true
    }
//    lazy var crashReporter = CrashReporter(crashReporterURL: URL(string: "")), privacyPolicyURL: URL(string: "https://example.com/privacy-policy")!)
    lazy var crashReporter = CrashReporter(
        crashReporterURL: crashReporterURL,
        privacyPolicyURL: URL(string: "https://example.com/privacy-policy")!)
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        UNUserNotificationCenter.current().delegate = self
//        
//        crashReporter.check(collectEmailAddress: true,
//                            alwaysShowCrashReporterWindow: true,
//                            displayCrashReporterWindowAsModal: true)
//        crashReporter.check(appName: "Unique")
//        crashApp(self)
//        WKWebViewWarmUper.shared.prepare()

        // Request authorization for posting user notifications.
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, error) in
                    // Enable or disable features based on authorization.
                }

        webLoaderURL = Bundle.main.url(forResource: "newtab", withExtension: "html")!.absoluteString
//        let em = NSAppleEventManager.shared()
//        em.setEventHandler(
//            self,
//            andSelector: #selector(getUrl(_:withReplyEvent:)),
//            forEventClass: AEEventClass(kInternetEventClass),
//            andEventID: AEEventID(kAEGetURL))
        
//        em.setEventHandler(self, andSelector: #selector(handleOpenEvent(_:withReplyEvent:)), forEventClass: AEEventClass(kCoreEventClass), andEventID: AEEventID(kAEOpenDocuments))
        //  Converted to Swift 5.3 by Swiftify v5.3.25403 - https://swiftify.com/
       
       
        
        replaceTabServiceWithInitialWindow()
        crashReporter.check(appName: "Unique", collectEmailAddress: true, alwaysShowCrashReporterWindow: true, displayCrashReporterWindowAsModal: true)
        
    }
    @IBAction func showPreferences(_ sender: Any) {
        var preferencesController: NSWindowController?

            if (preferencesController == nil) {
                let storyboard = NSStoryboard(name: NSStoryboard.Name("Preferences"), bundle: nil)
                preferencesController = storyboard.instantiateInitialController() as? NSWindowController
            }
            
            if (preferencesController != nil) {
                preferencesController!.showWindow(sender)
            }
        }
    func application(_ application: NSApplication, open urls: [URL]) {
        var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
        TransformProcessType(&psn, ProcessApplicationTransformState(kProcessTransformToForegroundApplication))
        print(urls)
        for url in urls {
            let snippet = url.absoluteString
            print(url)
            if url.absoluteString.hasSuffix("unextension/") {
//                ExtensionViewController(extensionPathOrNil: url)
               
                
                let sdf = ExtensionConfirmationSheet(extensionName: "test", extensionPath: url)
//                mmainWindowController?.browserVC.presentAsSheet(sdf)
//                mmainWindowController?.browserVC.presentAsModalWindow(sdf)
//                NSApp.windows[0].contentViewController?.presentAsModalWindow(sdf)
                NSApplication.shared.mainWindow?.contentViewController?.presentAsSheet(sdf)
            } else if let range = snippet.range(of: "extension?") {
            
            let phone = snippet[range.upperBound...]
            print(phone) // prints "023.456.7890"
            break
        } else if let range = snippet.range(of: "open?") {
            let phone = snippet[range.upperBound...]
            let urll = String(phone)
            if mywindowController.window?.isVisible == true {
                if let windowctr = tabService.mainWindow!.windowController as? WindowController {
                    webLoaderURL = urll
                    windowctr.addNewTab(self)
                    break
                }
            } else {
                webLoaderURL = urll
                replaceTabServiceWithInitialWindow()
                break
                }
            print(phone)
            break
        } else if let range = snippet.range(of: "do?") {
            let action = snippet[range.upperBound...]
            let task = String(action)
            if task == "refresh" {
                if mywindowController.window?.isVisible == true {
                    if let windowctr = tabService.mainWindow!.windowController as? WindowController {
                        windowctr.browserVC.mainWebView.reload()
                        break
                    }
                } else {
                    replaceTabServiceWithInitialWindow()
                    break
                    }
            } else if task == "back" {
                if mywindowController.window?.isVisible == true {
                    if let windowctr = tabService.mainWindow!.windowController as? WindowController {
                        windowctr.browserVC.mainWebView.goBack()
                        break
                    }
                } else {
                    replaceTabServiceWithInitialWindow()
                    break
                    }
            } else if task == "forward" {
                if mywindowController.window?.isVisible == true {
                    if let windowctr = tabService.mainWindow!.windowController as? WindowController {
                        windowctr.browserVC.mainWebView.goForward()
                        break
                    }
                } else {
                    replaceTabServiceWithInitialWindow()
                    break
                    }
            }
        } else if url.absoluteString.isValidURL {
            if mywindowController.window?.isVisible == true {
                if let windowctr = tabService.mainWindow!.windowController as? WindowController {
                    webLoaderURL = url.absoluteString
                    windowctr.addNewTab(self)
                    break
                }
            } else {
                webLoaderURL = url.absoluteString
                replaceTabServiceWithInitialWindow()
                break
                }
        } else {
            print("nothing")
            break
        }
        }
        // unique://open?https://google.com
        // unique://do?refresh -- refresh, back, forward,
        // unique://extension?https://www.github.com/Ashwin-Paudel/extension.zip
    }
    @IBAction func showDownloadsHistory(_ sender: Any?) {
        let mainWindow = NSWindow(contentViewController: DownloadsViewController(nibName: NSNib.Name("DownloadsViewController"), bundle: nil))
        mainWindow.title = "Downloads"
        mainWindow.titlebarAppearsTransparent = true
        mainWindow.makeKeyAndOrderFront(self)
    }
    @IBAction func showBrowsingHistory(_ sender: Any?) {
        let mainWindow = NSWindow(contentViewController: HistoryViewController(nibName: NSNib.Name("HistoryViewController"), bundle: nil))
        mainWindow.title = "History"
        mainWindow.titlebarAppearsTransparent = true
        mainWindow.makeKeyAndOrderFront(self)
        
    }
    /// Fallback for the menu bar action when all windows are closed.
    @IBAction func addNewTab(_ sender: Any?) {

        if let existingWindow = tabService.mainWindow {
            tabService.createTab(newWindowController: mywindowController,
                                 inWindow: existingWindow,
                                 ordered: .above)
        } else {
            replaceTabServiceWithInitialWindow()
        }
    }

   /// fallback for the menu bar action when all windows are closed.
    var mmainWindowController: WindowController?
    @IBAction func addNewWindow(_ sender: Any?) {
                self.mmainWindowController = WindowController()
                self.mmainWindowController?.showWindow(nil)
        if let existingWindow = mmainWindowController?.window {
            tabService.createTab(newWindowController: mmainWindowController!,
                                 inWindow: existingWindow,
                                 ordered: .above)
        } else {
            replaceTabServiceWithInitialWindow()
        }    }

    private func replaceTabServiceWithInitialWindow() {
        let windowController = mywindowController
        windowController.showWindow(self)
        tabService = TabService(initialWindowController: windowController)
    }
    private func showDebugWarning() {
        let alert = NSAlert()
        alert.messageText = "Cannot create crash log in DEBUG mode"
        alert.informativeText = "Change your Example.app scheme in Xcode to not run this with the \"Release\" build configuration and not as Debug Executable."
        alert.addButton(withTitle: "Continue")
        _ = alert.runModal()
    }
    let isDebuggerAttached: Bool = {
        var debuggerIsAttached = false

        var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var info: kinfo_proc = kinfo_proc()
        var info_size = MemoryLayout<kinfo_proc>.size

        let success = name.withUnsafeMutableBytes { (nameBytePtr: UnsafeMutableRawBufferPointer) -> Bool in
            guard let nameBytesBlindMemory = nameBytePtr.bindMemory(to: Int32.self).baseAddress else { return false }
            return -1 != sysctl(nameBytesBlindMemory, 4, &info, &info_size, nil, 0)
        }

        if !success {
            debuggerIsAttached = false
        }

        if !debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0 {
            debuggerIsAttached = true
        }

        return debuggerIsAttached
    }()
    @IBAction func crashApp(_ sender: Any?) {
        if isDebuggerAttached {
            showDebugWarning()
        } else {
            fatalError("Intentional crash.")
        }
    }

}

public func setAsDefaultBrowser() {
    let bundleID = Bundle.main.bundleIdentifier as CFString?
    var httpResult: OSStatus? = nil
    if let bundleID = bundleID {
        httpResult = LSSetDefaultHandlerForURLScheme("http" as CFString, bundleID)
        print(httpResult!)
    }
    var httpsResult: OSStatus? = nil
    if let bundleID = bundleID {
        httpsResult = LSSetDefaultHandlerForURLScheme("https" as CFString, bundleID)
        print(httpsResult!)
    }
    
    var fileResult: OSStatus? = nil
    if let bundleID = bundleID {
        fileResult = LSSetDefaultHandlerForURLScheme("HTML document" as CFString, bundleID)
        print(fileResult!)
    }
    
    var XHTMLdoc: OSStatus? = nil
    if let bundleID = bundleID {
        XHTMLdoc = LSSetDefaultHandlerForURLScheme("XHTML document" as CFString, bundleID)
        print(XHTMLdoc!)
    }

}

//public func updateApp() {
//        // MARK: - Stage 0: Delete the app
//        do {
//            // Replace Unique.app with your_app_name.app
//            try FileManager.default.removeItem(atPath: "/Applications/Unique.app")
//        } catch {
//            print("Error")
//        }
//        // MARK: - Stage 2: Download the new app
//        /// Compress your app in a zip, upload to github and get download link
//        /// Replace it with the zip download link
//        let url = URL(string: "https://github.com/Ashwin-Paudel/download/raw/main/Unique.zip")
//    let documentsUrl = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
//
//    FileDownloader.loadFileAsync(url: url!, path: documentsUrl) { (path, error) in
//
//// MARK: - Unzip the app and save to application folder
//            print("PDF File downloaded to : \(path!)")
//            let process = Process.launchedProcess(launchPath: "/usr/bin/unzip", arguments: ["-o", path!, "-d", "/Applications"])
//            process.waitUntilExit()
//        do {
//            // Replace Unique.app with your_app_name.app
//            try FileManager.default.removeItem(atPath: path!)
//        } catch {
//            print("Error")
//        }
//        }
//}
