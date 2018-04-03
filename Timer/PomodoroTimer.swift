import Foundation

class PomodoroTimer {
    enum Stage {
        case Work, ShortBreak, LongBreak
    }

    private var begin: Date
    private var secondsTillNextStage: Int
    private(set) var stage: Stage
    
    let MINUTES = 60
    
    init() {
        begin = Date.init()
        stage = Stage.Work
        secondsTillNextStage = 25 * MINUTES
    }
    
    func update(date: Date) -> Stage {
        let interval = date.timeIntervalSince(begin)
        if (Int(interval) > secondsTillNextStage) {
            begin = Date.init()

            switch stage {
            case .Work:
                stage = .ShortBreak
                secondsTillNextStage = 5 * MINUTES
            case .ShortBreak, .LongBreak:
                stage = .Work
                secondsTillNextStage = 25 * MINUTES
            }
        }
        return stage
    }
    
    func countDownTillNextStage(date: Date) -> Int {
        let interval = date.timeIntervalSince(begin)
        return secondsTillNextStage - Int(interval)
    }
}
