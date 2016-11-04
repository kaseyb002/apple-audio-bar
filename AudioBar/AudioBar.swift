import UIKit
import MediaPlayer

protocol RemainingTimeFormatting: class {

    func string(from timeInterval: TimeInterval) -> String?

}

extension DateComponentsFormatter: RemainingTimeFormatting {}

class AudioBar: UIView {

    let contentView = UIStackView()
    let routeView = MPVolumeView(showsVolumeSlider: false)
    let remainingTimeLabel = UILabel()

    var remainingTime: TimeInterval? {
        didSet {
            guard let remainingTime = remainingTime else {
                remainingTimeLabel.text = nil
                return
            }
            remainingTimeLabel.text = remainingTimeFormatter.string(from: remainingTime)
        }
    }

    let playbackControlsView = UIStackView()
    let previousButton = UIButton(type: .system)
    let playButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    var remainingTimeFormatter: RemainingTimeFormatting = DateComponentsFormatter(allowedUnits: [.minute, .second])

    init() {
        super.init(frame: .zero)
        initContentView()
        playbackControlsView.addArrangedSubview(previousButton)
        playbackControlsView.addArrangedSubview(playButton)
        playbackControlsView.addArrangedSubview(nextButton)
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

private extension DateComponentsFormatter {

    convenience init(allowedUnits: NSCalendar.Unit) {
        self.init()
        self.allowedUnits = allowedUnits
    }

}
