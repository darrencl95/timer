//
//  AppDelegate.swift
//  Timer
//
//  Created by Kazuyoshi Kato on 3/28/18.
//  Copyright © 2018 Kazuyoshi Kato. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    
    let rootItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBAction func quit(_ sender: NSMenuItem) {
        let app = NSApplication.shared
        app.terminate(self)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rootItem.title = "Pomodoro Timer"
        rootItem.menu = statusMenu
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

