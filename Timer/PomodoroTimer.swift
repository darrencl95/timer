import Foundation

class PomodoroTimer {
    enum Stage: TimeInterval {
        case Work = 25.0, ShortBreak = 5.0, LongBreak = 15.0
    }

    private var begin: Date
    private var secondsTillNextStage: Double
    private(set) var stage: Stage
    
    let MINUTES = 60.0
    
    init() {
        begin = Date.init()
        stage = Stage.Work
        secondsTillNextStage = 25 * MINUTES
    }
    
    func switchTo(stage: Stage, begin: Date) {
        self.stage = stage
        self.secondsTillNextStage = stage.rawValue * MINUTES
        self.begin = begin
    }
    
    func update(date: Date) -> Stage {
        let interval = date.timeIntervalSince(begin)
        if (interval > secondsTillNextStage) {
            let now = Date.init()

            switch stage {
            case .Work:
                switchTo(stage: Stage.ShortBreak, begin: now)
            case .ShortBreak, .LongBreak:
                switchTo(stage: Stage.Work, begin: now)
            }
        }
        return stage
    }
    
    func countDownTillNextStage(date: Date) -> Int {
        let interval = date.timeIntervalSince(begin)
        return Int(floor(secondsTillNextStage - interval))
    }
}
