//
//  AppDelegate.swift
//  Teams Enhance
//
//  Created by Jack on 12/10/24.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    private var statusBarMenu: NSMenu!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupStatusBarItem()
    }

    func setupStatusBarItem() {
        statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusBarItem.button {
            let  image = NSImage(named: "teams")
            image?.size = NSSize(width: 18, height: 18)
            image!.isTemplate = true
                   button.image = image

            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        statusBarMenu = NSMenu()
        statusBarMenu.addItem(NSMenuItem(title: "Open Teams", action: #selector(openTeams), keyEquivalent: ""))
        statusBarMenu.addItem(NSMenuItem.separator())
        statusBarMenu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        if event.type == NSEvent.EventType.rightMouseUp {
            statusBarItem.menu = statusBarMenu
            statusBarItem.button?.performClick(nil)
        } else {
            openTeams()
        }
    }

    @objc func openTeams() {
        let teamsURL = URL(string: "msteams:")!
        if NSWorkspace.shared.open(teamsURL) {
            print("Successfully opened Teams")
        } else {
            print("Failed to open Teams")
            // 如果无法打开Teams，可以尝试打开Teams的应用程序
            if let teamsAppURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.microsoft.teams") {
                NSWorkspace.shared.open(teamsAppURL)
            } else {
                let alert = NSAlert()
                alert.messageText = "Unable to open Teams"
                alert.informativeText = "Please make sure Microsoft Teams is installed on your system."
                alert.alertStyle = .warning
                alert.addButton(withTitle: "OK")
                alert.runModal()
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // 在应用终止时执行清理工作
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

