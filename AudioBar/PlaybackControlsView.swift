import UIKit

class PlaybackControlsView: UIStackView {

    let previousButton = PlaybackButton.make(for: .previous)
    let playButton = PlaybackButton.make(for: .play)
    let nextButton = PlaybackButton.make(for: .next)

    init() {
        super.init(frame: .zero)
        didInit()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func didInit() {
        addArrangedSubview(previousButton)
        addArrangedSubview(playButton)
        addArrangedSubview(nextButton)
        NSLayoutConstraint.activate(constraintsForButtons)
    }

    private var constraintsForButtons: [NSLayoutConstraint] {
        let buttons = [previousButton, playButton, nextButton]
        return buttons.flatMap(constraintsForButton)
    }

    private func constraintsForButton(button: UIButton) -> [NSLayoutConstraint] {
        return [
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ]
    }

}
