//import UIKit
//import MediaPlayer
//
//class AudioBar: UIStackView {
//
//    let routeView = MPVolumeView(showsVolumeSlider: false)
//    let playbackControlsView = PlaybackControlsView()
//    let remainingTimeLabel = RemainingTimeLabel()
//
//    init() {
//        super.init(frame: .zero)
//        didInit()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func didInit() {
//        addArrangedSubview(routeView)
//        addArrangedSubview(playbackControlsView)
//        addArrangedSubview(remainingTimeLabel)
//        distribution = .equalSpacing
//    }
//
//}
//
//private extension MPVolumeView {
//
//    convenience init(showsVolumeSlider: Bool) {
//        self.init()
//        self.showsVolumeSlider = showsVolumeSlider
//    }
//
//}
