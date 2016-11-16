import Foundation

protocol TimeFormatting: class {

    func string(from timeInterval: TimeInterval) -> String?
    
}

extension DateComponentsFormatter: TimeFormatting {}
