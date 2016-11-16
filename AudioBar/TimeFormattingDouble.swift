@testable import AudioBar

protocol TimeFormattingDouble: TimeFormatting {}

extension TimeFormattingDouble {

    func string(from timeInterval: TimeInterval) -> String? {
        return nil
    }

}
