import UIKit
import MediaPlayer

class AudioBar: UIView {

    let contentView = UIStackView()
    let routeView = MPVolumeView(showsVolumeSlider: false)
    let playbackControlsView = PlaybackControlsView()
    let remainingTimeLabel = RemainingTimeLabel()

    init() {
        super.init(frame: .zero)
        initContentView()
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

}

private extension MPVolumeView {

    convenience init(showsVolumeSlider: Bool) {
        self.init()
        self.showsVolumeSlider = showsVolumeSlider
    }

}
