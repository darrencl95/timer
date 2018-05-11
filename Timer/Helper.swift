import Cocoa

extension NSImage {
    func lockFocus(closure: () -> Void) {
        self.lockFocus()
        closure()
        self.unlockFocus()
    }
}

class Helper {
    static func monospaceMenuTitle(_ title: String) -> NSAttributedString {
        let str = NSMutableAttributedString.init(string: title)
        let monospaceFont = NSFont.init(name: "Menlo", size: NSFont.systemFontSize)
        str.setAttributes([NSAttributedStringKey.font: monospaceFont as Any], range: NSMakeRange(0, str.length))
        return str
    }
    
    static func makeClockImage(height: CGFloat, progress: Double) -> NSImage {
        let width = height
        
        let image = NSImage.init(size: NSMakeSize(width * 1.2, height))
        image.lockFocus {
            NSColor.controlTextColor.set()
            
            let path = NSBezierPath.init()
            let center = NSMakePoint(width/2, height/2)
            
            let radius = width * 0.4
            let end = 90.0 + CGFloat(360.0 * progress)
            
            path.move(to: center)
            path.appendArc(withCenter: center,
                           radius: radius, startAngle: 90, endAngle: end, clockwise: true)
            path.line(to: center)
            path.fill()
            
            path.move(to: NSMakePoint(center.x + radius, center.y))
            path.appendArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 360)
            path.lineWidth = 1
            path.stroke()
        }
        
        return image
    }
}
