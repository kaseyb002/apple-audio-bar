import UIKit
import MediaPlayer

class AudioBar: UIView {

    let contentView = UIStackView()
    let routeView = MPVolumeView(showsVolumeSlider: false)
    let remainingTimeLabel = RemainingTimeLabel()
    let playbackControlsView = UIStackView()
    let previousButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)

    init() {
        super.init(frame: .zero)
        initContentView()
        initPlaybackControlsView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initContentView() {
        addSubview(contentView)
        contentView.addArrangedSubview(routeView)
        contentView.addArrangedSubview(playbackControlsView)
        contentView.addArrangedSubview(remainingTimeLabel)
        contentView.distribution = .equalSpacing
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(contentViewConstraints)
    }

    private var contentViewConstraints: [NSLayoutConstraint] {
        return [
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
    }

    private func initPlaybackControlsView() {
        playbackControlsView.addArrangedSubview(previousButton)
        playbackControlsView.addArrangedSubview(playButton)
        playbackControlsView.addArrangedSubview(nextButton)
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

private extension MPVolumeView {

    convenience init(showsVolumeSlider: Bool) {
        self.init()
        self.showsVolumeSlider = showsVolumeSlider
    }

}
