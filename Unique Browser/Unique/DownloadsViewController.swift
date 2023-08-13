//
//  DownloadsViewController.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-09.
//

import Cocoa

class DownloadsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

//    @IBOutlet weak var tableView: NSTableView!

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidAppear() {
        super.viewDidAppear()
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Show in finder", action: #selector(showFileInFinder), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Download", action: #selector(redownloadFile), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Copy download URL", action: #selector(copyDownloadURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Remove From Download History", action: #selector(deleteFileFromList), keyEquivalent: ""))
        tableView.menu = menu
        
        
        tableView.delegate = self
        tableView.dataSource = self
        print(getDownloadListItem())
    }
    @objc func showFileInFinder() {
        let url = getDownloadListItem()?.root[tableView.clickedRow].filePath
        
        NSWorkspace.shared.selectFile(url, inFileViewerRootedAtPath: "")
    }
    @objc func deleteFileFromList() {
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let pListFilURL = uniqueDataDir()?.appendingPathComponent("downloads.plist")
        if !FileManager.default.fileExists(atPath: pListFilURL!.absoluteString) {
             FileManager.default.createFile(atPath: pListFilURL!.absoluteString, contents: "".data(using: .utf8), attributes: nil)
        }
        var allItems: [DownloadItem] = []
        allItems.append(contentsOf: getDownloadListItem()!.root)
        allItems.remove(at: tableView.clickedRow)
        let newList = DownloadList(root: allItems)
        do {
            let data = try encoder.encode(newList)
            try data.write(to: pListFilURL!)
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
    @objc func copyDownloadURL() {
        let url = getDownloadListItem()?.root[tableView.clickedRow].downloadURL
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url!, forType: .string)
            // Read copied string
            NSPasteboard.general.string(forType: .string)
    }
    @objc func redownloadFile() {
        let downloadURL = getDownloadListItem()?.root[tableView.clickedRow].downloadURL
        let downloadFilePath = getDownloadListItem()?.root[tableView.clickedRow].filePath
        let downloadFileNmae = getDownloadListItem()?.root[tableView.clickedRow].fileName

        
//        let newdownloaditem = DownloadItem(downloadURL: url!, filePath: url2!, fileName: url3!)
        
        NSWorkspace.shared.open(URL(string: downloadURL!)!)
//            NSWorkspace.shared.open((panel.url?.appendingPathComponent(response.suggestedFilename!))!)
            
        }
//
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return getDownloadListItem()!.root.count
//    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return getDownloadListItem()!.root.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = getDownloadListItem()!.root[row].fileName + " - " + getDownloadListItem()!.root[row].downloadURL
        return cell
    }
}
