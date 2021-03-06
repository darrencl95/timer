import Foundation

class PomodoroTimer {
    enum Stage: TimeInterval {
        case Work = 25.0, ShortBreak = 5.0, LongBreak = 15.0
    }

    private(set) var since: Date
    private var secondsTillNextStage: Double
    private(set) var stage: Stage
    private(set) var workCount: Int
    
    let MINUTES = 60.0
    
    init() {
        since = Date.init()
        stage = Stage.Work
        secondsTillNextStage = 25 * MINUTES
        workCount = 0
    }
    
    func switchTo(_ stage: Stage, since: Date) {
        self.stage = stage
        self.secondsTillNextStage = stage.rawValue * MINUTES
        self.since = since
    }
    
    func update(date: Date) -> Stage {
        let interval = date.timeIntervalSince(since)
        if (interval > secondsTillNextStage) {
            let now = Date.init()

            switch stage {
            case .Work:
                workCount += 1
                if workCount == 4 {
                    switchTo(Stage.LongBreak, since: now)
                    workCount = 0
                } else {
                    switchTo(Stage.ShortBreak, since: now)
                }
            case .ShortBreak, .LongBreak:
                switchTo(Stage.Work, since: now)
            }
        }
        return stage
    }
    
    func countDownTillNextStage(date: Date) -> Int {
        let interval = date.timeIntervalSince(since)
        return Int(floor(secondsTillNextStage - interval))
    }
}
