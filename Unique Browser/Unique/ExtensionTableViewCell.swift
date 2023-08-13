//
//  ExtensionTableViewCell.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-12.
//

import Cocoa

class ExtensionTableViewCell: NSTableCellView {

    @IBOutlet weak var extImage: NSImageView!
    @IBOutlet weak var extName: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
