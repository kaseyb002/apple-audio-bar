import UIKit
import AVFoundation
import MediaPlayer
import Elm

public final class AudioBarViewController: UIViewController, ElmDelegate {

    public typealias Module = AudioBarModule

    typealias Model = AudioBarModule.Model
    typealias View = AudioBarModule.View

    private let program = Module.makeProgram()
    private let player = AVPlayer()
    private let volumeView: MPVolumeView = MPVolumeView()

    @IBOutlet private var playPauseButton: UIButton!
    @IBOutlet private var seekBackButton: UIButton!
    @IBOutlet private var seekForwardButton: UIButton!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var audioRouteView: UIView!

    @IBAction func userDidTapPlayPauseButton() {
        program.dispatch(.togglePlay)
    }

    @IBAction func userDidTapSeekForwardButton() {
        program.dispatch(.seekForward)
    }

    @IBAction func userDidTapSeekBackButton() {
        program.dispatch(.seekBack)
    }

    public func loadURL(url: URL) {
        program.dispatch(.prepareToLoad(url))
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        volumeView.showsVolumeSlider = false
        volumeView.setRouteButtonImage(loadImage(withName: "AirPlay Icon"), for: .normal)
        audioRouteView.addSubview(volumeView)
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel.font.pointSize, weight: UIFontWeightRegular)
        program.setDelegate(self)
        player.addPeriodicTimeObserver(forInterval: CMTime(timeInterval: 0.1), queue: nil) { [weak player, weak program] time in
            guard let currentTime = player?.currentTime().timeInterval else { return }
            program?.dispatch(.playerDidUpdateCurrentTime(currentTime))
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        volumeView.frame = audioRouteView.bounds
    }

    public func program(_ program: Program<Module>, didUpdate view: Module.View) {
        var playPauseButtonImage: UIImage {
            switch view.playPauseButtonMode {
            case .play: return loadImage(withName: "Play Button")
            case .pause: return loadImage(withName: "Pause Button")
            }
        }
        playPauseButton.setImage(playPauseButtonImage, for: .normal)
        playPauseButton.isEnabled = view.isPlayPauseButtonEnabled
        seekBackButton.isHidden = view.areSeekButtonsHidden
        seekBackButton.isEnabled = view.isSeekBackButtonEnabled
        seekForwardButton.isHidden = view.areSeekButtonsHidden
        seekForwardButton.isEnabled = view.isSeekForwardButtonEnabled
        timeLabel.text = view.playbackTime
        loadingIndicator.isHidden = !view.isLoadingIndicatorVisible
    }

    public func program(_ program: Program<Module>, didEmit command: Module.Command) {

        switch command {

        case .player(let command):
            switch command {
            case .loadURL(let url):
                let playerItem = AVPlayerItem(url: url)
                beginObservingPlayerItem(playerItem)
                player.replaceCurrentItem(with: playerItem)
            case .reset:
                guard let playerItem = player.currentItem else { preconditionFailure() }
                endObservingPlayerItem(playerItem)
                player.replaceCurrentItem(with: nil)
            case .play:
                player.play()
            case .pause:
                player.pause()
            case .setCurrentTime(let time):
                player.seek(to: CMTime(timeInterval: time))
            }

        case .showAlert(text: let text, button: let button):
            let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: button, style: .default, handler: nil))
            present(alertController, animated: true)

        }

    }

    private func beginObservingPlayerItem(_ playerItem: AVPlayerItem) {
        playerItem.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: playerItem, queue: nil) { [weak program] _ in
            program?.dispatch(.playerDidPlayToEnd)
        }
    }

    private func endObservingPlayerItem(_ playerItem: AVPlayerItem) {
        playerItem.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
    }

    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let playerItem = player.currentItem, keyPath == #keyPath(AVPlayerItem.status) {
            guard change![.oldKey] as! NSValue != change![.newKey] as! NSValue else { return }

            switch playerItem.status {
            case .unknown:
                break
            case .readyToPlay:
                program.dispatch(.playerDidBecomeReadyToPlay(withDuration: playerItem.duration.timeInterval))
            case .failed:
                program.dispatch(.playerDidFailToBecomeReady)
            }

        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    private func loadImage(withName name: String) -> UIImage {
        let bundle = Bundle(for: AudioBarViewController.self)
        return UIImage(named: name, in: bundle, compatibleWith: traitCollection)!
    }

}

extension CMTime {

    init(timeInterval: TimeInterval) {
        self = CMTime(seconds: timeInterval, preferredTimescale: 44100)
    }

    var timeInterval: TimeInterval {
        return CMTimeGetSeconds(self)
    }
    
}
