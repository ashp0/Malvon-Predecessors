//
//  ToolbarSearchField.swift
//  Unique
//
//  Created by Ashwin Paudel on 2021-02-04.
//

import Cocoa

class URLSearchfield: NSSearchField {

    var title: String?
    var borderColor: NSColor?

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        if let textEditor = currentEditor() {
            textEditor.selectAll(self)
        }
    }
    override func mouseEntered(with event: NSEvent) {
        
    }
    convenience init(withValue: String?, modalTitle: String?) {
        self.init()

        if let string = withValue {
            self.stringValue = string
        }
        if let title = modalTitle {
            self.title = title
        }
        self.cell?.controlView?.wantsLayer = true
        self.cell?.controlView?.layer?.borderWidth = 5
        self.lineBreakMode = .byTruncatingHead
        self.usesSingleLineMode = true
    }
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let cell = self.cell as? NSSearchFieldCell {
            cell.cancelButtonCell?.isTransparent = true
        }
        
        if let color = borderColor {
            self.layer?.borderColor = color.cgColor
            let path = NSBezierPath.init(rect: frame)
            path.lineWidth = 1
            color.setStroke()
            path.stroke()
            if self.window?.firstResponder == self.currentEditor() && NSApp.isActive {
                NSGraphicsContext.saveGraphicsState()
                NSFocusRingPlacement.only.set()
                NSGraphicsContext.restoreGraphicsState()
            }
        }
        var focus = false

        if let firstResponder = self.window?.firstResponder {
            if firstResponder.isKind(of: NSSearchField.self) {
                // swiftlint:disable force_cast
                let textView = firstResponder as! NSSearchField
                if let clipView = textView.superview {
                    if let textField = clipView.superview {
                        if textField == self {
                            focus = true
                        }
                    }
                }
            }
        }

        if focus {
            let bounds = self.bounds
            let outerRect = NSMakeRect(bounds.origin.x - 2, bounds.origin.y - 2, bounds.size.width + 4, bounds.size.height + 4)
            let innerRect = NSInsetRect(outerRect, 1, 1)
            let clipPath = NSBezierPath(rect: outerRect)
            clipPath.append(NSBezierPath(rect: innerRect))
            clipPath.windingRule = NSBezierPath.WindingRule.evenOdd
            clipPath.setClip()

            NSColor(calibratedWhite: 0.6, alpha: 1.0).setFill()
            NSBezierPath(rect: outerRect).fill()
            self.backgroundColor = NSColor(cgColor: CGColor(red: 1, green: 0.4, blue: 0.5, alpha: 0.4))
        }
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()

        if let title = self.title {
            self.window?.title = title
        }
        // MARK: this gets us focus even when modal
        self.becomeFirstResponder()
    }
//    override func mouseExited(with event: NSEvent) {
//        window?.makeFirstResponder(window?.contentViewController)
//    }
//    override func mouseMoved(with event: NSEvent) {
//        window?.makeFirstResponder(window?.contentViewController)
//    }
}
