//
//  MATabBar.swift
//  Malvon
//
//  Created by Ashwin Paudel on 2022-10-02.
//  Copyright © 2022 Ashwin Paudel. All rights reserved.
//

import Cocoa

fileprivate let tabBarHeight = 30.0
fileprivate let tabBarWidth = 120.0

final class FlippedView: NSClipView {
    override var isFlipped: Bool {
        return true
    }
}

class MATabBar: NSView {
    private let stackView = NSStackView()
    private let scrollView = NSScrollView()
    private let containerView = FlippedView()
    
    func configure() {
        wantsLayer = true
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = false
        scrollView.hasVerticalRuler = false
        scrollView.drawsBackground = false
        scrollView.verticalScrollElasticity = .none
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: tabBarHeight)
        ])
        
        containerView.drawsBackground = false
        scrollView.contentView = containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        scrollView.documentView = stackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        stackView.orientation = .horizontal
        stackView.distribution = .gravityAreas
        stackView.alignment = .centerY
        stackView.spacing = 0.5
    }
    
    func update() {
        // Should use some sort of algorithm to check the array
        // Instead of re-rendering the data
        
        stackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        for _ in Shared.tabs {
            add()
        }
    }
    
    open func add() {
        let newButton = MATabBarButton(frame: .zero)
        newButton.configure()
        
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.heightAnchor.constraint(equalToConstant: tabBarHeight).isActive = true
        newButton.widthAnchor.constraint(equalToConstant: tabBarWidth).isActive = true
        newButton.tag = stackView.subviews.count
        
        if newButton.tag == 3 {
            newButton.isSelectedTab = true
        }
        
        newButton.title = ""
        newButton.target = self
        newButton.action = #selector(buttonClicked(_:))
        newButton.wantsLayer = true
        
        newButton.bezelStyle = .shadowlessSquare
        
        stackView.addArrangedSubview(newButton)
    }
    
    @objc func buttonClicked(_ sender: NSButton) {
        print("Hello world")
    }
}
