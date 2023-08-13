//
//  BrowserViewController.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-05.
//

import Cocoa
import WebKit
import UserNotifications

var webLoaderURL = "https://www.google.com/"

class BrowserViewController: NSViewController, WKUIDelegate, WKNavigationDelegate, NSWindowDelegate, WKScriptMessageHandler {
    
//    @IBOutlet weak var extensionListView: NSBox!
    @IBOutlet weak var mainWebView: WKWebView!
    var popUpwebView: WKWebView?
    
    @IBOutlet weak var downloadProgressIndicator: NSProgressIndicator!
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
            let content = UNMutableNotificationContent()
        content.title = "\(mainWebView.title!) - \(mainWebView.url!)"
            content.body = message.body as! String
        
            let uuidString = UUID().uuidString
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: nil)
        

            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request) { (error) in
                if error != nil {
                    NSLog(error.debugDescription)
                }
            }
        }
   
    @IBOutlet weak var collectionView: NSCollectionView!
    
    let subview = ExtensionTableViewList(nibName: "ExtensionTableViewList", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
       Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(viewDidLoadFuntion), userInfo: nil, repeats: false)
    }
    
     @objc func viewDidLoadFuntion() {
//        super.viewDidLoad()
        downloadProgressIndicator.isHidden = true
        
//        extensionListView.contentView = ExtensionTableViewList(nibName: "ExtensionTableViewList", bundle: nil).view
     
        addChild(subview)
        subview.view.frame = NSRect(x: 0, y: 0, width: 50, height: view.bounds.height)
        subview.view.autoresizingMask = [.height]

        
        self.view.addSubview(subview.view)
        
//        subview.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true

//        self.view.addSubview(controller.view)
//        subview.view.widthAnchor = NSLayoutDimension().constraint(equalTo: <#T##NSLayoutAnchor<NSLayoutDimension>#>)
         // tell the childviewcontroller it's contained in it's parent
//        subview.didMove(toParentViewController: self)
        print("sdfsadjfiasdjfiasdjfiasdjfsaidfj")
        
//        mainWebView = WKWebView(frame: view.bounds)
//        mainWebView.frame = view.bounds
//        mainWebView.autoresizingMask = [.width, .height]
//        view.addSubview(mainWebView)
       
        
        let userScriptURL = Bundle.main.url(forResource: "UserScript", withExtension: "js")!
                let userScriptCode = try! String(contentsOf: userScriptURL)
                let userScript = WKUserScript(source: userScriptCode, injectionTime: .atDocumentStart, forMainFrameOnly: false)
                
                // Create the custom configuration to use for the web view.
        let configuration = mainWebView.configuration
                configuration.userContentController.addUserScript(userScript)
                configuration.userContentController.add(self, name: "notify")
        installAdBlock()
        callAdBlock1()
        //_aggressiveTileRetentionEnabled
        mainWebView.configuration.preferences.setValue(true, forKey: "offlineApplicationCacheIsEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "aggressiveTileRetentionEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "screenCaptureEnabled")
        mainWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        mainWebView.configuration.preferences.setValue(true, forKey: "allowsPictureInPictureMediaPlayback")
        mainWebView.configuration.preferences.setValue(true, forKey: "fullScreenEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "largeImageAsyncDecodingEnabled")
        mainWebView.configuration.preferences.setValue(false, forKey: "animatedImageAsyncDecodingEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "usesPageCache")
        mainWebView.configuration.preferences.setValue(true, forKey: "mediaSourceEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "acceleratedDrawingEnabled")
        mainWebView.configuration.preferences.setValue(false, forKey: "backspaceKeyNavigationEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "mediaDevicesEnabled")
        // webView.configuration.preferences.setValue(true, forKey: "subpixelAntialiasedLayerTextEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "mockCaptureDevicesPromptEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "canvasUsesAcceleratedDrawing")
        mainWebView.configuration.preferences.setValue(true, forKey: "aggressiveTileRetentionEnabled")
        mainWebView.configuration.preferences.setValue(true, forKey: "videoQualityIncludesDisplayCompositingEnabled")
        mainWebView.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15 Unique/1"
        
        
//        let url = Bundle.main.url(forResource: "newtab", withExtension: "html")!
        mainWebView.load(URLRequest(url: URL(string: webLoaderURL)!))
        mainWebView.uiDelegate = self
        mainWebView.navigationDelegate = self
        self.mainWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        mainWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
    }
    override func viewWillDisappear() {
        super.viewWillDisappear()
//        let script = """
//           const event = new Event("beforeunload", { cancellable: true });
//           const cancelled = !window.dispatch(event);
//           // return back whether the user cancelled
//           cancelled;
//        """
//
//        mainWebView.evaluateJavaScript(script, completionHandler: { result, error in
//           guard let cancelled = result else { return }
//          // swiftlint:disable force_cast
//            if cancelled as! Int == 1 {
//             // ... do whatever
////                self.view.window?.close()
//            } else {
//            }
//        })
        mainWebView.removeObserver(self, forKeyPath: "estimatedProgress")
        mainWebView.removeObserver(self, forKeyPath: #keyPath(WKWebView.title))
        mainWebView.loadHTMLString("", baseURL: nil)
//        mainWebView?.stopLoading()
//        mainWebView = nil
//        self.mainWebView.removeFromSuperview()

    }
//
//    func windowWillClose(_ notification: Notification) {
////        mainWindow.isReleasedWhenClosed = false
//        popUpwebView = nil
//    }
    func windowWillClose(_ notification: Notification) {
        let window = notification.object as? NSWindow
        if window == mainWindow {
            popUpwebView = nil
            mainWindow.windowController = nil
        }
        NotificationCenter.default.removeObserver(self, name: NSWindow.willCloseNotification, object: window)
    }
    func windowShouldClose(_ sender: NSWindow) -> Bool {

        #if DEBUG
        let closingCtl = sender.contentViewController!
        let closingCtlClass = closingCtl.className
        print("\(closingCtlClass) is closing")
        #endif


        sender.contentViewController = nil // will force deinit.

        return true // allow to close.
    }
    
    func printTimestamp() -> String {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "MMM d, h:mm a"
        let dateString = df.string(from: date)
        return dateString
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        UNUpdateUtilities.download()
        if UserDefaults.standard.bool(forKey: "isExtensionSidebarShown") {
            subview.view.isHidden = true
            mainWebView.frame = view.bounds
            UserDefaults.standard.setValue(true, forKey: "isExtensionSidebarShown")
        } else {
            subview.view.isHidden = false
            
           mainWebView.frame = view.bounds
            mainWebView.frame = NSRect(x: 50, y: 0, width: view.bounds.width - 50, height: view.bounds.height)
            UserDefaults.standard.setValue(false, forKey: "isExtensionSidebarShown")
        }
        if 1 == 1 {
            let newhistoryitem = HistoryItem(url: mainWebView.url!.absoluteString, title: mainWebView.title!, date: printTimestamp())
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let pListFilURL = uniqueDataDir()?.appendingPathComponent("history.plist")
            if !FileManager.default.fileExists(atPath: pListFilURL!.absoluteString) {
                 FileManager.default.createFile(atPath: pListFilURL!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
            }
            var allItems: [HistoryItem] = []
            allItems.append(contentsOf: getHistoryListItem()!.root)
//            allItems.append(contentsOf: getHistoryListItem()!.root)
            allItems.append(newhistoryitem)
            let newList = HistoryList(root: allItems)
            do {
                let data = try encoder.encode(newList)
                try data.write(to: pListFilURL!)
            } catch {
                print(error)
            }
        }
        var requestmy = URLRequest(url: mainWebView.url!)
                                 
        requestmy.cachePolicy = .returnCacheDataDontLoad

        
//        DispatchQueue.global().async { [self] in
//            if let content = try? String(contentsOf: mainWebView.url!, encoding: .utf8) {
//                DispatchQueue.main.async { [self] in
//                  if let range = mainWebView.url?.absoluteString.range(of: "type=") {
//                    let phone = mainWebView.url?.absoluteString[range.upperBound...]
//                    let urll = String(phone!)
//                        print(phone)
//                    }
//                }
//            }
//        }
        
        let windowController = self.view.window?.windowController as? WindowController
        windowController?.progressIndicator.isHidden = true
        self.view.window?.tab.title = mainWebView.title
        if mainWebView.url == Bundle.main.url(forResource: "newtab", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?newtab"
        } else if mainWebView.url == Bundle.main.url(forResource: "settings", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?settings"
        } else {
            windowController?.searchField.stringValue = self.mainWebView.url!.absoluteString
        }

        let url = Bundle.main.url(forResource: "newtab", withExtension: "html")!
        webLoaderURL = url.absoluteString
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        var requestmy = URLRequest(url: mainWebView.url!)
                                 
        requestmy.cachePolicy = .returnCacheDataDontLoad
        
//        let cache = URLCache(
//            memoryCapacity: 2048576 /* 2M */,
//            diskCapacity: 10737412742 /* 128M */,
//            diskPath: myPath.absoluteString)
//        URLCache.shared = cache
        
        URLCache.shared = {
                URLCache(memoryCapacity: 2048576, diskCapacity: 10737412742, diskPath: nil)
        }()
        
        let windowController = self.view.window?.windowController as? WindowController
        windowController?.progressIndicator.isHidden = false
        if mainWebView.url == Bundle.main.url(forResource: "newtab", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?newtab"
        } else if mainWebView.url == Bundle.main.url(forResource: "settings", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?settings"
        } else {
            windowController?.searchField.stringValue = self.mainWebView.url!.absoluteString
        }
        if webView.canGoBack {
            windowController?.bfrSegmentControl.setEnabled(true, forSegment: 0)
        } else {
            windowController?.bfrSegmentControl.setEnabled(false, forSegment: 0)
        }
        if webView.canGoForward {
            windowController?.bfrSegmentControl.setEnabled(true, forSegment: 1)
        } else {
            windowController?.bfrSegmentControl.setEnabled(false, forSegment: 1)
        }
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = NSAlert()
        alert.messageText = "Alert!"
        alert.informativeText = message
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Ok")
        alert.beginSheetModal(for: self.view.window!) { (response) in
            completionHandler()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.mainWebView.estimatedProgress)
            let windowController = self.view.window?.windowController as? WindowController
            windowController?.progressIndicator.doubleValue = (self.mainWebView.estimatedProgress * 100) + 10
            if mainWebView.url == Bundle.main.url(forResource: "newtab", withExtension: "html")! {
                windowController?.searchField.stringValue = "unique?newtab"
            } else {
//                windowController?.searchField.stringValue = self.mainWebView.url!.absoluteString
            }
//            if windowController?.progressIndicator.doubleValue == 0 {
                windowController?.progressIndicator.increment(by: 50)
//                            }
            windowController?.progressIndicator.usesThreadedAnimation = true
                            if windowController?.progressIndicator.doubleValue == 100 {
                                windowController?.progressIndicator.doubleValue = 0
                                windowController?.progressIndicator.isHidden = true
                            }
        }
        if keyPath == "title" {
                if let title = mainWebView.title {
                    
                    self.view.window?.tab.title = title
                }
            }
    }
    func installAdBlock() {
        if let url1 = URL(string: "https://raw.githubusercontent.com/brave/brave-ios/development/Client/WebFilters/ContentBlocker/Lists/block-ads.json") {
                do {
                    let contents = try String(contentsOf: url1)
                    let dataDir = uniqueDataDir()?.appendingPathComponent("adblock.json")
                    
                    do {
                        try contents.write(to: dataDir!, atomically: true, encoding: .utf8)
                    } catch {
                    }
                } catch {
                }
        }
    }
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask,
                    willCacheResponse proposedResponse: CachedURLResponse,
                    completionHandler: @escaping (CachedURLResponse?) -> Void) {
        if proposedResponse.response.url?.scheme == "https" {
            let updatedResponse = CachedURLResponse(response: proposedResponse.response,
                                                    data: proposedResponse.data,
                                                    userInfo: proposedResponse.userInfo,
                                                    storagePolicy: .allowed)
            completionHandler(updatedResponse)
        } else {
            let newResponse = CachedURLResponse(response: proposedResponse.response,
                                                    data: proposedResponse.data,
                                                    userInfo: proposedResponse.userInfo,
                                                    storagePolicy: .allowed)
            completionHandler(newResponse)
        }
    }
    func callAdBlock1() {
        if let url1 = uniqueDataDir()?.appendingPathComponent("adblock.json") {
                do {
                    let contents = try String(contentsOf: url1)
                    WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "ContentBlockingRules", encodedContentRuleList: contents) { (contentRuleList, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                            if self.mainWebView == nil {
                            } else {
                                self.mainWebView.configuration.userContentController.add(contentRuleList!)
                            }
                    }
                } catch {} // contents could not be loaded
            } else {} // the url was bad
        }
    // When the website wants to open a file
        func webView(_ webView: WKWebView, runOpenPanelWith parameters: WKOpenPanelParameters, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping ([URL]?) -> Void) {
            // Create the file panel
            let dialog = NSOpenPanel()
            
            // Check if the webview wants multiple selections
            if parameters.allowsMultipleSelection == true {
                dialog.allowsMultipleSelection = true
            }
            // Check if the webview alloes chossing directories
            if parameters.allowsDirectories == true {
                dialog.canChooseDirectories = true
            }
            
            // Show the file panel
            dialog.beginSheetModal(for: self.view.window!) { result in
                // If the user uploads a file complete
                if result == .OK {
                    if let url = dialog.url {
                        // Upload the file url to the webpage
                        completionHandler([url])
                    }
                } else {
                    // If the user clicks cancle
                    self.complete(nil)
                }
            }
        }
    
//    var mainWindow: NSWindow!
    var mainWindow = NSWindow(contentRect: .init(origin: .zero,
                                                 size: .init(width: 1000,
                                                             height: 1000)),
                       styleMask: [.closable, .titled, .resizable, .miniaturizable],
                              backing: .buffered,
                              defer: false)
    
    
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            
            
            let height =  CGFloat(windowFeatures.height?.intValue ?? 1000)
            let width = CGFloat(windowFeatures.width?.intValue ?? 1000)
            let xxxx = CGFloat(windowFeatures.x?.intValue ?? 50)
            let yyyy = CGFloat(windowFeatures.x?.intValue ?? 50)
            
            NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowWillClose(_:)), name: NSWindow.willCloseNotification, object: mainWindow)
            
//                mainWindow.titlebarAppearsTransparent = true
            
            let popupwebviewctr = PopupWebViewController(configuration: configuration)
            popupwebviewctr.view.autoresizingMask = [.height, .width]
                mainWindow.contentViewController = popupwebviewctr
//            let adsfasdf = NSWindow(contentViewController: popupwebviewctr)
                mainWindow.delegate = self
            
            var windowscd: WindowController = WindowController()
            mainWindow.windowController = windowscd
//                popUpwebView?.customUserAgent = mainWebView.customUserAgent
                mainWindow.tabbingMode = .disallowed
    //            DispatchQueue.global().async {
    //                if let content = try? String(contentsOf: navigationAction.request.url!, encoding: .utf8) {
    //                    DispatchQueue.main.async { [self] in
    //                        if let range = content.range(of: "<title>.*?</title>", options: .regularExpression, range: nil, locale: nil) {
    //                            let title = content[range].replacingOccurrences(of: "</?title>", with: "", options: .regularExpression, range: nil)
    //                            print(title)
    //                            mainWindow.title = title
    //                        }
    //                    }
    //                }
    //            }
        //        if navigationAction.targetFrame?.isMainFrame == true {
        ////            mainWindow.makeKeyAndOrderFront(mainWindow)
        //        } else {
        //            mainWindow.toolbar = self.view.window?.toolbar
                    mainWindow.makeKeyAndOrderFront(self)
//                mainWindow.addTitlebarAccessoryViewController(openInBrowser(url: navigationAction.request.url!.absoluteString, window: self.view.window!, webView: popUpwebView!))
            
            mainWindow.addTitlebarAccessoryViewController(openInBrowser(url: navigationAction.request.url!.absoluteString, window: self.view.window!, webView: popupwebviewctr.popUpwebView!))
//            let sdifasdfisjfds = openInBrowser(url: mainWebView.url, window: self.view.window, webView: popupwebviewctr.popUpwebView)
//            mainWindow.addTitlebarAccessoryViewController(sdifasdfisjfds)
                
                
//                mainWindow.center()
    //        }
            
                
    //        }
//            adsfasdf.makeKeyAndOrderFront(self)
            //        mainWindow.backgroundColor = .blue
            return popupwebviewctr.popUpwebView
        }
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popUpwebView = nil
        //        self.view.window?.close()
        mainWindow.close()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.view.window?.tab.title = mainWebView.title
        self.mainWebView.autoresizesSubviews = true
        
        let windowController = self.view.window?.windowController as? WindowController
        if mainWebView.url == Bundle.main.url(forResource: "newtab", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?newtab"
        } else if mainWebView.url == Bundle.main.url(forResource: "settings", withExtension: "html")! {
            windowController?.searchField.stringValue = "unique?settings"
        } else {
            windowController?.searchField.stringValue = self.mainWebView.url!.absoluteString
        }
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        let request = navigationAction.request
        let url = request.url
//
//        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { (cookies) in
//             HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
//        }

        decisionHandler(.allow)
        return
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            // get header and print it
            if let response = navigationResponse.response as? HTTPURLResponse {
                if let fields = response.allHeaderFields["Content-Type"] as? String {
                    if fields.contains("text/html") {
                    } else {
                        print("Code asdfasdfasdf")
                        
                        let urllli = mainWebView.url
                        let panel = NSOpenPanel()
                        panel.allowsMultipleSelection = false
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.canCreateDirectories = true
                        panel.beginSheetModal(for: self.view.window!) { [self] (respone) in
                            if respone == .OK {
                                let newdownloaditem = DownloadItem(downloadURL: response.url!.absoluteString, filePath: panel.url!.absoluteString, fileName: response.suggestedFilename!)
                                let encoder = PropertyListEncoder()
                                encoder.outputFormat = .xml
                                let pListFilURL = uniqueDataDir()?.appendingPathComponent("downloads.plist")
                                if !FileManager.default.fileExists(atPath: pListFilURL!.absoluteString) {
                                     FileManager.default.createFile(atPath: pListFilURL!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
                                }
                                var allItems: [DownloadItem] = []
                                allItems.append(contentsOf: getDownloadListItem()!.root)
                                allItems.append(newdownloaditem)
                                let newList = DownloadList(root: allItems)
                                do {
                                    let data = try encoder.encode(newList)
                                    try data.write(to: pListFilURL!)
                                } catch {
                                    print(error)
                                }
                                downloadProgressIndicator.isHidden = false
                                let tim = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] timer in
                                            if MyVariables.isDone == true {
                                                MyVariables.isDone = false
//                                                self.dismiss(self)
                                                timer.fire()
                                            }
                                    downloadProgressIndicator.doubleValue = MyVariables.downloadProgress
                                    }
                                FileDownloader.loadFileAsync(url: response.url!, path: panel.url!) { (path, error) in
                                    print("PDF File downloaded to : \(path!)")
                                    DispatchQueue.main.async {
                                        let filePath = panel.url?.appendingPathComponent(response.suggestedFilename!)
                                        NSWorkspace.shared.selectFile(filePath?.absoluteString, inFileViewerRootedAtPath: "")
                                        downloadProgressIndicator.isHidden = true
                                    }
                                }
                            } else {
                            }
                        }
                        
                        decisionHandler(.cancel)
                    }
                    print("Code hererr \(fields)")
                }
                print("Code here \(response)")
            }
            decisionHandler(.allow)
        }
}

/*
 let myURLString = "http://www.google.com/s2/favicons?domain=www.facebook.com"
 let myURL = NSURL(string: myURLString)!
 let myData = NSData.dataWithContentsOfURL(myURL)
 let myImage = UIImage(data: myData)!
 */



public func readPlistFile(_ path: String, _ key: String) -> Any {
    let dataDir = URL(string: path)
    let output: Any
    if let dict = NSDictionary(contentsOf: dataDir!) {
        output = dict.object(forKey: key)
        return output
    }
    print("errorororororoorororororororoororororororo")
    return ("yo" as! Any)
}
public func createPlistFile(_ data: [String: String], _ name: String) {
    do {
        let dicData = NSDictionary(dictionary: data)
        let path = uniqueDataDir()?.appendingPathComponent("\(name).plist")
        dicData.write(toFile: path!.absoluteString, atomically: true)
    } catch {
    }
}

public func writePlistFile(_ name: String, _ key: String, data: Any) {
    let dataDir = uniqueDataDir()?.appendingPathComponent("\(name).plist")
    if let dict = NSMutableDictionary(contentsOf: dataDir!) {
        dict.setObject(data, forKey: key as NSCopying)
        if dict.write(toFile: dataDir!.absoluteString, atomically: true) {
            print("sucsess")
        }
    }
}

public struct DownloadList: Codable {
    let root: [DownloadItem]
}
public struct DownloadItem: Codable {
    let downloadURL: String
    let filePath: String
    let fileName: String
}

public struct HistoryList: Codable {
    let root: [HistoryItem]
}
public struct HistoryItem: Codable {
    let url: String
    let title: String
    let date: String
}
public struct ExtensionList: Codable {
    let root: [ExtensionItem]
}
public struct ExtensionItem: Codable {
    let path: String
}

public func getDownloadListItem() ->  DownloadList? {
    let decoder = PropertyListDecoder()
    let url = uniqueDataDir()?.appendingPathComponent("downloads.plist")
    if let data = try? Data(contentsOf: url!) {
        if let settings = try? decoder.decode(DownloadList.self, from: data) {
            return settings
        }
    }
    return nil
}
public func getHistoryListItem() ->  HistoryList? {
    let decoder = PropertyListDecoder()
    let url = uniqueDataDir()?.appendingPathComponent("history.plist")
    if !FileManager.default.fileExists(atPath: url!.absoluteString) {
         FileManager.default.createFile(atPath: url!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
    }
    if let data = try? Data(contentsOf: url!) {
        if let settings = try? decoder.decode(HistoryList.self, from: data) {
            return settings
        }
    }
    return nil
}
public func getExtensionListItem() ->  ExtensionList? {
    let decoder = PropertyListDecoder()
    let url = uniqueDataDir()?.appendingPathComponent("extensions.plist")
    if !FileManager.default.fileExists(atPath: url!.absoluteString) {
         FileManager.default.createFile(atPath: url!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
    }
    if let data = try? Data(contentsOf: url!) {
        if let settings = try? decoder.decode(ExtensionList.self, from: data) {
            return settings
        }
    }
    return nil
}
extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
