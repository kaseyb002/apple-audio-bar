import XCTest
@testable import AudioBar

extension AudioBar.Model.ReadyState {
    init(isPlaying: Bool = false, duration: TimeInterval = 60, currentTime: TimeInterval? = nil) {
        self.isPlaying = isPlaying
        self.duration = duration
        self.currentTime = currentTime
    }
}

extension URL {
    static var arbitrary: URL {
        return URL(string: "foo")!
    }
}
