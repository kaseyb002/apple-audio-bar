import UIKit

class PlaybackControlsView: UIStackView {

    let previousButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)

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
        NSLayoutConstraint.activate(playBackButtonsConstraints)
    }

    private var playBackButtonsConstraints: [NSLayoutConstraint] {
        return [
            previousButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            previousButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            playButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44),
            nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ]
    }
    
}
