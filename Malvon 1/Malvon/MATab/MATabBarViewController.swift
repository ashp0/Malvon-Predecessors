//
//  MATabBar.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-09-15.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

class MATabBarViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var backwardButton: NSButton!
    
    @IBOutlet weak var forwardButton: NSButton!
    
    @IBOutlet weak var refreshButton: NSButton!
    
    lazy var tableViewMenu: NSMenu = {
        let menu = NSMenu()
        menu.addItem(withTitle: "Close Tab", action: #selector(RCMCloseTab), keyEquivalent: "")
        
        return menu
    }()
    
    override func viewWillAppear() {
        //        static var backwardButton: NSButton!
        //        static var forwardButton: NSButton!
        //        static var refreshButton: NSButton!
        Shared.backwardButton = backwardButton
        Shared.forwardButton = forwardButton
        Shared.refreshButton = refreshButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.action = #selector(tableViewAction(_:))
        tableView.menu = tableViewMenu
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return Shared.tabs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: nil) as? NSTableCellView else { return nil }
        
        cell.textField?.stringValue = Shared.tabs[row].title
        
        return cell
    }
    
    func update() {
        tableView.reloadData()
        tableView.selectRowIndexes(.init(integer: Shared.current), byExtendingSelection: false)
    }
    
    
    @objc func tableViewAction(_ sender: NSTableView) {
        let row = sender.selectedRow
        
        Shared.tabView!.switch(row)
    }
    
    // Right click menu
    @objc func RCMCloseTab() {
        guard tableView.clickedRow != -1 else { return }
        
        Shared.tabView!.remove(tableView.selectedRow)
    }
}
