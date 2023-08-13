//
//  openInBrowser.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-06.
//
import Cocoa
import WebKit


class openInBrowser: NSTitlebarAccessoryViewController, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        webVie.navigationDelegate = self
        self.layoutAttribute = .right
        
    }
    var urlll = ""
    var windddow = NSWindow()
    var webVie = WKWebView()
    @IBAction func openInBrowser(_ sender: Any) {
        openBorwser(url: webVie.url!.absoluteString)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.windddow.title =
        self.view.window?.title  = webVie.title!
    }
//    convenience init() {
//            self.init(urlll: nil)
//        }
    init(url: String, window: NSWindow, webView: WKWebView) {
            self.urlll = url
        self.windddow = window
        self.webVie = webView
            super.init(nibName: "openInBrowser", bundle: nil)
        }
    func openBorwser(url: String) {
        self.windddow.orderFront(nil)
        NSWorkspace.shared.open(URL(string: "un://open?\(url)")!)
        self.view.window?.close()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
