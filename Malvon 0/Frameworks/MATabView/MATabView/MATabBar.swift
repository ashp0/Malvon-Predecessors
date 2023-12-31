//
//  MATabBar.swift
//  MATabView
//
//  Created by Ashwin Paudel on 2022-02-03.
//

import Cocoa

final class FlippedView: NSClipView {
    override var isFlipped: Bool {
        return true
    }
}

@objc public protocol MATabBarDelegate: NSObjectProtocol {
    @objc optional func tabBar(_ tabBarView: MATabBar, didSelect tab: MATab)
    @objc optional func tabBar(_ tabBarView: MATabBar, wantsToClose tab: MATab)
    @objc optional func tabBar(_ tabBarView: MATabBar, wantsToHide tab: MATab)
    @objc optional func tabBar(wantsToUnhideAllTabs tabBarView: MATabBar)
    @objc optional func tabBar(wantsToUnhide tabBarView: MATabBar, at position: Int)
    @objc optional func tabBar(wantsToDisplayHiddenItemMenu tabBarView: MATabBar) -> [MATab]
}

open class MATabBar: NSView, MATabBarItemDelegate {
    private let stackView = NSStackView()
    private let scrollView = NSScrollView()
    private let containerView = FlippedView()
    open var configuration = MATabViewConfiguration()
    open weak var delegate: MATabBarDelegate?
    open var tabView: MATabView?

    // MARK: - Configuring

    private final func configureViews() {
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
            scrollView.heightAnchor.constraint(equalToConstant: configuration.tabHeight)
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

        let menu = NSMenu()
        let subMenuItem = NSMenuItem()
        subMenuItem.title = "Hidden Tabs"
        subMenuItem.identifier = NSUserInterfaceItemIdentifier("MATabBarHiddenItemSubMenu")
        subMenuItem.isEnabled = true
        menu.addItem(subMenuItem)

        menu.addItem(withTitle: "Unhide all tabs", action: #selector(unhideAllTabs), keyEquivalent: "")
        self.menu = menu
    }

    override open func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        for item in menu.items {
            if item.identifier?.rawValue == "MATabBarHiddenItemSubMenu" {
                item.isEnabled = true
                let hiddenTabs = delegate?.tabBar?(wantsToDisplayHiddenItemMenu: self)
                let subMenu = NSMenu()

                if let hiddenTabs = hiddenTabs {
                    for (position, hiddenTab) in hiddenTabs.enumerated() {
                        item.submenu = subMenu
                        let menuItem = NSMenuItem(title: hiddenTab.title, action: #selector(unHideMenuItem), keyEquivalent: "")
                        menuItem.tag = position
                        subMenu.addItem(menuItem)
                    }
                }
            }
        }
    }

    @objc func unHideMenuItem(_ sender: NSMenuItem) {
        sender.isHidden = true
        delegate?.tabBar?(wantsToUnhide: self, at: sender.tag)
    }

    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        wantsLayer = true
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"

        if appearance == "Dark" {
            layer?.backgroundColor = configuration.darkTabBackgroundColor.cgColor
        } else {
            layer?.backgroundColor = configuration.lightTabBackgroundColor.cgColor
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    override public required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureViews()
    }

    public func tabBarItem(_ tabBarItem: MATabBarItem, wantsToClose tab: MATab) {
        delegate?.tabBar?(self, wantsToClose: tab)
    }

    public func tabBarItem(_ tabBarItem: MATabBarItem, wantsToHide tab: MATab) {
        delegate?.tabBar?(self, wantsToHide: tab)
    }

    @objc func unhideAllTabs() {
        delegate?.tabBar?(wantsToUnhideAllTabs: self)
    }

    // MARK: - Tab Functions

    open func move(tab: MATabBarItem, at: Int) {
        stackView.insertArrangedSubview(tab, at: at)
        var tabs = [MATab]()

        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            tabs.append((subview as! MATabBarItem).tab)
            (subview as! MATabBarItem).tab.position = index
        }

        tabView!.updateTabIndexes(tabs: tabs)
    }

    open func remove(tab: MATab) {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.allowsImplicitAnimation = true

            stackView.arrangedSubviews[tab.position].alphaValue = 0.0
        } completionHandler: { [self] in
            stackView.arrangedSubviews[tab.position].removeFromSuperview()
        }
        // Remap the position of each tab
        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            (subview as! MATabBarItem).tab.position = index
        }
    }

    open func updateTabIndexes() {
        for (index, subview) in stackView.arrangedSubviews.enumerated() {
            (subview as! MATabBarItem).tab.position = index
        }
    }

    open func add(tab: MATab) {
        let newButton = MATabBarItem(frame: .zero, tab: tab)

        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.heightAnchor.constraint(equalToConstant: configuration.tabHeight).isActive = true
        newButton.widthAnchor.constraint(equalToConstant: configuration.tabWidth).isActive = true
        newButton.tag = stackView.subviews.count
        newButton.configuration = configuration

        newButton.title = ""
        newButton.target = self
        newButton.action = #selector(selectedTab(_:))
        newButton.wantsLayer = true
        newButton.delegate = self

        newButton.bezelStyle = .shadowlessSquare
        newButton.tabBar = self

        stackView.addArrangedSubview(newButton)
    }

    open func handleDraggingTab(draggingRect: NSRect, tab: MATabBarItem) {
        var moved = false
        let position = Int(draggingRect.minX / configuration.tabWidth)

        if !(position < stackView.arrangedSubviews.count) && !moved {
            move(tab: tab, at: position - 1)
            moved = true
        }
    }

    @objc func selectedTab(_ sender: MATabBarItem) {
        delegate?.tabBar?(self, didSelect: sender.tab)
    }

    // MARK: - Get

    open func isEmpty() -> Bool {
        return stackView.arrangedSubviews.isEmpty
    }

    public func get(tabItem at: Int) -> MATabBarItem {
        return stackView.arrangedSubviews[at] as! MATabBarItem
    }

    public var tabCount: Int {
        return stackView.arrangedSubviews.count
    }

    open func updateColors(configuration: MATabViewConfiguration, selectedTab: MATab) {
        self.configuration = configuration
        scrollView.heightAnchor.constraint(equalToConstant: configuration.tabHeight).isActive = true
        let appearance = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"

        if appearance == "Dark" {
            layer?.backgroundColor = configuration.darkTabBackgroundColor.cgColor
        } else {
            layer?.backgroundColor = configuration.lightTabBackgroundColor.cgColor
        }
//
//        for view in stackView.arrangedSubviews {
//            (view as! MATabBarItem).updateColors(configuration: configuration)
        (stackView.arrangedSubviews[selectedTab.position] as! MATabBarItem).updateColors(configuration: configuration)
//        }
    }
}
