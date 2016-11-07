import UIKit

class PlaybackButton: UIButton {

    private(set) var playbackAction: PlaybackAction?

    enum PlaybackAction {
        case previous
        case play
        case pause
        case next
    }

    static func make(for playbackAction: PlaybackAction) -> PlaybackButton {
        let button = PlaybackButton(type: .system)
        button.playbackAction = playbackAction
        button.didInit()
        return button
    }

    private func didInit() {
        addConstraints(sizeConstraints)
    }

    private var sizeConstraints: [NSLayoutConstraint] {
        return [
            heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ]
    }
    
}
