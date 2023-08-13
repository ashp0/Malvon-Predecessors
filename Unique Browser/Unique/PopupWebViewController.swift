//
//  PopupWebViewController.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-14.
//

import Cocoa
import WebKit

class PopupWebViewController: NSViewController {
    
    var popUpwebView: WKWebView?

    init(configuration: WKWebViewConfiguration) {
        super.init(nibName: "PopupWebViewController", bundle: nil)
        popUpwebView = WKWebView(frame: view.bounds, configuration: configuration)
                popUpwebView!.autoresizingMask = [.width, .height]
        view.addSubview(popUpwebView!)
        popUpwebView?.customUserAgent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15 Unique/1"
    }
    override func viewWillDisappear() {
        print("dasfasdfijasdifjasldfijasldfijdsoifasodjfis--asdfasdf")
        popUpwebView = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
