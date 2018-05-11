import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var label: NSTextField!

    // Menu
    @IBOutlet weak var statusMenu: NSMenu!
    @IBOutlet weak var resetOrStopItem: NSMenuItem!

    let rootItem: NSStatusItem
    var timer: Timer!
    let pomodoroTimer: PomodoroTimer

    override init() {
        self.rootItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.timer = nil
        self.pomodoroTimer = PomodoroTimer.init()
        
        let fewMinutesAgo = Date.init().addingTimeInterval(-(60 * 24.5))
        pomodoroTimer.switchTo(PomodoroTimer.Stage.Work, since: fewMinutesAgo)

        super.init()
    }
    
    func resetTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(update(timer:)),
                                     userInfo: nil,
                                     repeats: true)
        timer.fire()

        pomodoroTimer.switchTo(PomodoroTimer.Stage.Work, since: Date.init())
    }

    @IBAction func resetOrStopTimerAction(_ sender: NSMenuItem) {
        if timer.isValid {
            stop(nil)
        } else {
            resetTimer()
        }
        
        updateMenu()
    }
    
    @IBAction func stop(_ sender: NSButton?) {
        timer.invalidate()
        updateTimer()
        updateMenu()
        window!.setIsVisible(false)
        rootItem.attributedTitle = NSAttributedString.init(string: "")
    }
    
    @IBAction func quit(_ sender: NSMenuItem) {
        let app = NSApplication.shared
        app.terminate(self)
    }
    
    func updateTimer() {
        let now = Date.init()
        let newStage = pomodoroTimer.update(date: now)
        
        window!.setIsVisible(newStage != .Work)
        
        let seconds = pomodoroTimer.countDownTillNextStage(date: now)
        updateRootItem(seconds)
        
        label.stringValue = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
    
    @objc func update(timer: Timer) {
        updateTimer()
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

        updateMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func updateRootItem(_ seconds: Int) {
        let title = String.init(format: "%02d:%02d", seconds / 60, seconds % 60)
        rootItem.attributedTitle = Helper.monospaceMenuTitle(title)
        
        if let button = rootItem.button {
            var p = 0.0
            if timer.isValid {
                p = Double(seconds) / (pomodoroTimer.stage.rawValue * 60.0)
            }
            let image = Helper.makeClockImage(height: 18, progress: p)
            button.image = image
            button.alternateImage = image
        }
    }
    
    func updateMenu() {
        if timer.isValid {
            resetOrStopItem.title = "Stop Pomodoro"
        } else {
            resetOrStopItem.title = "Start Pomodoro"
        }
    }
}

