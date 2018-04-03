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
   
    let rootItem: NSStatusItem
    var timer: Timer!
    let pomodoroTimer: PomodoroTimer

    override init() {
        self.rootItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.timer = nil
        self.pomodoroTimer = PomodoroTimer.init()
        super.init()
    }

    @IBAction func quit(_ sender: NSMenuItem) {
        let app = NSApplication.shared
        app.terminate(self)
    }
    
    @objc func update(timer: Timer) {
        let now = Date.init()

        let oldStage = pomodoroTimer.stage
        let newStage = pomodoroTimer.update(date: now)
        
        if (oldStage != newStage) {
            switch newStage {
            case .ShortBreak, .LongBreak:
                NSLog("break")
            case .Work:
                NSLog("work")
            }
        }
        
        let seconds = pomodoroTimer.countDownTillNextStage(date: now)
        rootItem.title = String.init(format: "\(newStage) - %02d:%02d", seconds / 60, seconds % 60)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,
                                          selector: #selector(update(timer:)), userInfo: nil, repeats: true)

        rootItem.title = "Pomodoro Timer"
        rootItem.menu = statusMenu
        
        //pomodoroTimer.reset()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

