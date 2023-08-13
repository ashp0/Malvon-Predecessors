//
//  ExtensionViewController.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-05.
//

import Cocoa
import WebKit

class ExtensionViewController: NSViewController {

    var jsonData = ""
    var document = "test data1"
    var extensionPopupView: WKWebView!
    
    init(fileURL: URL?) {
        super.init(nibName: "ExtensionViewController", bundle: nil)
        if fileURL != nil {
            if self.view.window?.isVisible != true {
                let withoutbrackets = fileURL!.absoluteString.replacingOccurrences(of: "Optional(", with: "")
                let withoutbracketss = fileURL!.absoluteString.replacingOccurrences(of: ")", with: "")
let urllsls = URL(string: withoutbracketss)
                print(urllsls)
                print(fileURL)
                print("uhiushdf")
                let sdaf = WKWebViewConfiguration()
                extensionPopupView = WKWebView(frame: view.bounds, configuration: sdaf)
                extensionPopupView!.autoresizingMask = [.width, .height]
                view.addSubview(extensionPopupView)
            extensionPopupView.loadFileURL(urllsls!, allowingReadAccessTo: urllsls!)
            } else {
                let withoutbrackets = fileURL!.absoluteString.replacingOccurrences(of: "Optional(", with: "")
                let withoutbracketss = fileURL!.absoluteString.replacingOccurrences(of: ")", with: "")
let urllsls = URL(string: withoutbracketss)
                print(urllsls)
                print(fileURL)
                print("uhiushdf")
                let sdaf = WKWebViewConfiguration()
                extensionPopupView = WKWebView(frame: view.bounds, configuration: sdaf)
                extensionPopupView!.autoresizingMask = [.width, .height]
                view.addSubview(extensionPopupView)
            extensionPopupView.loadFileURL(urllsls!, allowingReadAccessTo: urllsls!)
                
        }
        }
    }
    override func viewDidAppear() {
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var mylabel: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // swiftlint:disable force_cast superfluous_disable_command
        do {
            try document.write(to: (uniqueDataDir()?.appendingPathComponent("extension.json"))!, atomically: true, encoding: .utf8)
        } catch {
        }
    }
}

// MARK: - Extension JSON File Decoder

struct EXTFileElement: Decodable {
    let name, dir: String
}

typealias EXTFile = [EXTFileElement]
