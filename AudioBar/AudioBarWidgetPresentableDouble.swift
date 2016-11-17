protocol AudioBarWidgetPresentableDouble: AudioBarWidgetPresentable {}

extension AudioBarWidgetPresentableDouble {

    var isPlaying: Bool { return false }
    var canSeekBack: Bool { return false }
    var canSeekForward: Bool { return false }
    var remainingTime: TimeInterval { return 0 }

}
