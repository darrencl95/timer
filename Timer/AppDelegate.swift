//
//  AppDelegate.swift
//  Timer
//
//  Created by Kazuyoshi Kato on 3/28/18.
//  Copyright © 2018 Kazuyoshi Kato. All rights reserved.
//

import Cocoa

extension NSImage {
    func lockFocus(closure: () -> Void) {
        self.lockFocus()
        closure()
        self.unlockFocus()
    }
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var label: NSTextField!

    let rootItem: NSStatusItem
    var timer: Timer!
    let pomodoroTimer: PomodoroTimer

    override init() {
        self.rootItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.timer = nil
        self.pomodoroTimer = PomodoroTimer.init()
        
        let fewMinutesAgo = Date.init().addingTimeInterval(-(10 * 60))
        pomodoroTimer.switchTo(PomodoroTimer.Stage.Work, since: fewMinutesAgo)

        super.init()
    }

    @IBAction func quit(_ sender: NSMenuItem) {
        let app = NSApplication.shared
        app.terminate(self)
    }
    
    func monospaceMenuTitle(_ title: String) -> NSAttributedString {
        let str = NSMutableAttributedString.init(string: title)
        let monospaceFont = NSFont.init(name: "Menlo", size: NSFont.systemFontSize)
        str.setAttributes([NSAttributedStringKey.font: monospaceFont as Any], range: NSMakeRange(0, str.length))
        return str
    }
    
    func makeClockImage(height: CGFloat, progress: Double) -> NSImage {
        let width = height

        let image = NSImage.init(size: NSMakeSize(width * 1.2, height))
        image.lockFocus {
            NSColor.textColor.set()
            
            let path = NSBezierPath.init()
            let center = NSMakePoint(width/2, height/2)
            
            let end = CGFloat(90.0 + 360.0 * progress)
        
            path.move(to: center)
            path.appendArc(withCenter: center,
                           radius: width * 0.4, startAngle: 90, endAngle: end, clockwise: true)
            path.line(to: center)
            path.fill()

            path.move(to: center)
            path.appendArc(withCenter: center, radius: width * 0.4, startAngle: 0, endAngle: 360)
            path.lineWidth = 2
            path.stroke()
        }
        
        return image
    }
    
    @objc func update(timer: Timer) {
        let now = Date.init()
        let newStage = pomodoroTimer.update(date: now)

        window!.setIsVisible(newStage != .Work)
        
        let seconds = pomodoroTimer.countDownTillNextStage(date: now)
        
        let title = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
        rootItem.attributedTitle = monospaceMenuTitle(title)

        
        if let button = rootItem.button {
            let p = Double(seconds) / (pomodoroTimer.stage.rawValue * 60.0)
            let image = makeClockImage(height: 18, progress: p)
            button.image = image
            button.alternateImage = image
        }
        label.stringValue = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    func stopTimer(sender: NSButton) {
        
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                          selector: #selector(update(timer:)), userInfo: nil, repeats: true)

        rootItem.title = ""
        rootItem.menu = statusMenu
        
        window.level = NSWindow.Level.screenSaver
        let screenSize = NSScreen.main!.frame.size

        var frame = NSZeroRect
        frame.origin = NSMakePoint(0, 0)
        frame.size = NSMakeSize(screenSize.width, screenSize.height)
        window.setFrame(frame, display: true, animate: false)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

