protocol AudioBarWidgetPresentable {

    var isPlaying: Bool { get }
    var canSeekBack: Bool { get }
    var canSeekForward: Bool { get }
    var remainingTime: TimeInterval { get }

}
