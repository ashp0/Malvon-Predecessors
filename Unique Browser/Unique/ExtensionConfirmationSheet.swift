//
//  ExtensionConfirmationSheet.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-20.
//

import Cocoa

class ExtensionConfirmationSheet: NSViewController {

    @IBOutlet weak var yesBTN: NSButton!
    
    @IBOutlet weak var noBTN: NSButton!
    
    var extensionPath = URL(string: "")
    override func viewDidLoad() {
        super.viewDidLoad()
        noBTN.isHighlighted = true
        // Do view setup here.
    }
    init(extensionName: String, extensionPath: URL) {
        super.init(nibName: "ExtensionConfirmationSheet", bundle: nil)
//        presentAsSheet(self)
        self.extensionPath = extensionPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBAction func yesAction(_ sender: Any) {
        let newhistoryitem = ExtensionItem(path: extensionPath!.absoluteString)
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let pListFilURL = uniqueDataDir()?.appendingPathComponent("extensions.plist")
        if !FileManager.default.fileExists(atPath: pListFilURL!.absoluteString) {
             FileManager.default.createFile(atPath: pListFilURL!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
        }
        var allItems: [ExtensionItem] = []
        allItems.append(contentsOf: getExtensionListItem()!.root)
//            allItems.append(contentsOf: getHistoryListItem()!.root)
        allItems.append(newhistoryitem)
        let newList = ExtensionList(root: allItems)
        do {
            let data = try encoder.encode(newList)
            try data.write(to: pListFilURL!)
        } catch {
            print(error)
        }
        self.dismiss(self)
    }
    
    @IBAction func noAction(_ sender: Any) {
        self.dismiss(self)
    }
}
