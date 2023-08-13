//
//  ExtensionTableViewList.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-12.
//

import Cocoa
import WebKit

class ExtensionTableViewList: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var tableView: NSTableView!
    var browserVC: BrowserViewController {
        let contentViewController = self.parent as! BrowserViewController
        return contentViewController
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isEnabled = true
        let menu = NSMenu()
        menu.addItem(withTitle: "Turn Off All Extension", action: #selector(removeUserScipt), keyEquivalent: "")
        tableView.menu = menu
        tableView.doubleAction = #selector(tableViewDoubleAction)
        // Do view setup here.
    }
    @IBAction func addNewExtension(_ sender: Any) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["unextension"]
        panel.beginSheetModal(for: self.view.window!) { [self] (responce) in
            if responce == .OK {
                let sdf = ExtensionConfirmationSheet(extensionName: "test", extensionPath: panel.url!)
                NSApplication.shared.mainWindow?.contentViewController?.presentAsSheet(sdf)
            }
    }
    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return getExtensionListItem()!.root.count
       }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
          guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "extensionTableViewListCellView"), owner: self) as? ExtensionTableViewCell else { return nil }
          
        cell.extName.stringValue = ""
      // Good
        let infolist: URL = URL(string: getExtensionListItem()!.root[row].path)!.appendingPathComponent("Contents/Info.plist")
        print("sdfadf")
        print(infolist)

        let imageURL = readPlistFile(infolist.absoluteString, "icon")
        print("asdfasdfsdfasd")
        print(imageURL)
        let iconPath = readPlistFile(infolist.absoluteString, "icon") as! String
            let imageURLDir = URL(string: getExtensionListItem()!.root[row].path)!.appendingPathComponent("Contents/\(iconPath)")
            print(imageURLDir)
        print("itsts abocves")
        let imageImageImage = imageURLDir.absoluteString.replacingOccurrences(of: "file:///", with: "")
        
        cell.extImage.image = NSImage(contentsOfFile: imageImageImage)

        
          return cell
      }
    //removeUserScipt
    @objc func removeUserScipt() {
        browserVC.mainWebView.configuration.userContentController.removeAllUserScripts()
    }
    @objc func tableViewDoubleAction() {
        print("sadhfiadsf")
        let isIndexValid = getExtensionListItem()?.root.indices.contains(tableView.clickedRow)
        if isIndexValid == true {
            print("sadhfiaasdfiasjdfiasjdfdsf")

        

        if let clickedRow = URL(string: getExtensionListItem()!.root[tableView.clickedRow].path) {
            var errror = false
            let popover = NSPopover()
            popover.behavior = .transient
            var infolist: URL = clickedRow.appendingPathComponent("Contents/Info.plist")
            let scripts = readPlistFile(infolist.absoluteString, "scripts") as! [String]
            for mysiprt in scripts {
                let firstSciptURL = clickedRow.appendingPathComponent("Contents/\(mysiprt)")
                print("HIHIHIHIHIHIHIHdd \(firstSciptURL)")
                do {
                    if firstSciptURL == nil {
                        break
                    } else {
                        let contents = try String(contentsOf: firstSciptURL)
                    let scriptttt = WKUserScript(source: contents, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
                    browserVC.mainWebView.configuration.userContentController.addUserScript(scriptttt)
                    var scriptsCount = 0
                    scriptsCount += 1
                    if scriptsCount == scripts.count {
                        break
                    }
                    }
                } catch {
                    print("HIHIHIHIHIHIHIH \(error)")
                    let alert = NSAlert()
                    alert.messageText = "Error"
                    alert.informativeText = error.localizedDescription
                    alert.runModal()
                    errror = true
                }
            }
            if errror != true {
            let popUpViewName = readPlistFile(infolist.absoluteString, "popoverview") as! String
                let popupWebViewURL: URL = clickedRow.appendingPathComponent("Contents/\(popUpViewName)")
            popover.contentViewController = ExtensionViewController(fileURL: popupWebViewURL)
    //            ExtensionViewController(fileURL: popupWebViewURL)
            popover.show(relativeTo: tableView.rect(ofRow: tableView.selectedRow), of: tableView.rowView(atRow: tableView.selectedRow, makeIfNecessary: false)!, preferredEdge: .maxX)
            }
        }
        } else {
            print("asdfajdfiasjdfsdfjasdifjasdofi")
        }
//        let rectttttt = NSRect(x: 700, y: 400, width: 250, height: 250)
//        popover.show(relativeTo: rectttttt, of: tableView, preferredEdge: .minX)
    }
}
