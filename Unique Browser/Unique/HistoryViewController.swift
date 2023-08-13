//
//  HistoryViewController.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-10.
//

import Cocoa

class HistoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    var reversedData: [HistoryItem] = getHistoryListItem()!.root.reversed()
    override func viewDidAppear() {
        super.viewDidAppear()
//        reversedData = getHistoryListItem()!.root.reversed()
refreshData(self)
        //        tableView.layer?.setAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi))
//        cell.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open", action: #selector(openURL), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Copy", action: #selector(copyHistoryURL), keyEquivalent: ""))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Remove From History", action: #selector(deleteFileFromList), keyEquivalent: ""))
        tableView.menu = menu
        tableView.doubleAction = #selector(openURL)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        print(getHistoryListItem())
    }
    @objc func openURL() {
        let url = reversedData[tableView.clickedRow].url
        NSWorkspace.shared.open(URL(string: url)!)
    }
    @objc func deleteFileFromList() {
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let pListFilURL = uniqueDataDir()?.appendingPathComponent("history.plist")
        
        var allItems: [HistoryItem] = []
        allItems.append(contentsOf: reversedData)
        allItems.remove(at: tableView.clickedRow)
        let newList = HistoryList(root: allItems)
        do {
            let data = try encoder.encode(newList)
            try data.write(to: pListFilURL!)
//            refreshData(self)
        } catch {
            print(error)
        }
    }
    @IBAction func refreshData(_ sender: Any) {
        reversedData = getHistoryListItem()!.root.reversed()
        tableView.reloadData()
    }
    @objc func copyHistoryURL() {
        let url = reversedData[tableView.clickedRow].url
        
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(url, forType: .string)
            // Read copied string
            NSPasteboard.general.string(forType: .string)
    }
//
//    func numberOfRows(in tableView: NSTableView) -> Int {
//        return reversedData.count
//    }
    func numberOfRows(in tableView: NSTableView) -> Int {
        return reversedData.count
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        if (tableColumn?.identifier)!.rawValue == "historyTitle" {
            
            cell.textField?.stringValue = reversedData[row].title
               } else if (tableColumn?.identifier)!.rawValue == "historyURL" {
                cell.textField?.stringValue = reversedData[row].url
               } else {
                cell.textField?.stringValue = reversedData[row].date
               }
//        cell.layer?.setAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi))
        
return cell
    }
    
}
