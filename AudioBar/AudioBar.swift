import Foundation
import Elm

public struct AudioBar: Elm.Module {

    public enum PlayPauseButtonMode {
        case play
        case pause
    }

    public struct Flags {}

    public enum Message {
        case prepareToLoad(URL?)
        case togglePlayPauseButton(withMode: PlayPauseButtonMode)
        case seekBack
        case seekForward
        case playerDidBecomeReadyToPlay(withDuration: TimeInterval)
        case playerDidFailToBecomeReady
        case playerDidUpdateCurrentTime(TimeInterval)
        case playerDidPlayToEnd
    }

    public enum Model {
        public struct ReadyState {
            var isPlaying: Bool
            var duration: TimeInterval
            var currentTime: TimeInterval?
        }
        case waitingForURL
        case readyToLoadURL(URL)
        case waitingForPlayerToBecomeReadyToPlayURL(URL)
        case readyToPlay(ReadyState)
        static let seekInterval: TimeInterval = 15
    }

    public enum Command {
        public enum Player {
            case loadURL(URL?)
            case play
            case pause
            case setCurrentTime(TimeInterval)
        }
        case player(Player)
        case showAlert(text: String, button: String)
    }

    public struct View {
        let playPauseButtonMode: PlayPauseButtonMode
        let isPlayPauseButtonEnabled: Bool
        let areSeekButtonsHidden: Bool
        let playbackTime: String
        let isSeekBackButtonEnabled: Bool
        let isSeekForwardButtonEnabled: Bool
        let isLoadingIndicatorVisible: Bool
    }

    public enum Failure: Error {
        case noURL
        case waitingForURL
        case readyToLoadURL
        case notReadyToPlay
        case playing
        case notPlaying
        case waitingToBecomeReadyToPlay
        case notWaitingToBecomeReadyToPlay
    }

    public static func start(with flags: Flags, perform: (Command) -> Void) throws -> Model {
        return .waitingForURL
    }

    public static func update(for message: Message, model: inout Model, perform: (Command) -> Void) throws {
        switch message {
        case .prepareToLoad(let url):
            let isPlayerActive: Bool = {
                switch model {
                case .waitingForURL:
                    return false
                case .readyToLoadURL:
                    return false
                case .waitingForPlayerToBecomeReadyToPlayURL:
                    return true
                case .readyToPlay:
                    return true
                }
            }()
            if isPlayerActive {
                perform(.player(.loadURL(nil)))
            }
            if let url = url {
                model = .readyToLoadURL(url)
            } else {
                model = .waitingForURL
            }
        case .togglePlayPauseButton(.play):
            switch model {
            case .waitingForURL:
                throw Failure.noURL
            case .readyToLoadURL(at: let url):
                model = .waitingForPlayerToBecomeReadyToPlayURL(url)
                perform(.player(.loadURL(url)))
            case .waitingForPlayerToBecomeReadyToPlayURL:
                throw Failure.waitingToBecomeReadyToPlay
            case .readyToPlay(var state):
                guard !state.isPlaying else { throw Failure.playing }
                state.isPlaying = true
                model = .readyToPlay(state)
                perform(.player(.play))
            }
        case .togglePlayPauseButton(.pause):
            switch model {
            case .waitingForURL:
                throw Failure.waitingForURL
            case .readyToLoadURL:
                throw Failure.readyToLoadURL
            case .waitingForPlayerToBecomeReadyToPlayURL(let url):
                model = .readyToLoadURL(url)
                perform(.player(.loadURL(nil)))
            case .readyToPlay(var state):
                guard state.isPlaying else { throw Failure.notPlaying }
                state.isPlaying = false
                model = .readyToPlay(state)
                perform(.player(.pause))
            }
        case .seekBack:
            guard case .readyToPlay(var state) = model else {
                throw Failure.notReadyToPlay
            }
            state.currentTime = max(0, state.currentTime! - Model.seekInterval)
            model = .readyToPlay(state)
            perform(.player(.setCurrentTime(state.currentTime!)))
        case .seekForward:
            guard case .readyToPlay(var state) = model else {
                throw Failure.notReadyToPlay
            }

            let currentTime = min(state.duration, state.currentTime! + Model.seekInterval)
            state.currentTime = currentTime
            perform(.player(.setCurrentTime(currentTime)))

            if currentTime == state.duration && state.isPlaying {
                state.isPlaying = false
                perform(.player(.pause))
            }

            model = .readyToPlay(state)
        case .playerDidBecomeReadyToPlay(withDuration: let duration):
            guard case .waitingForPlayerToBecomeReadyToPlayURL = model else {
                throw Failure.notWaitingToBecomeReadyToPlay
            }
            model = .readyToPlay(.init(isPlaying: true, duration: duration, currentTime: nil))
            perform(.player(.play))

        case .playerDidPlayToEnd:
            guard case .readyToPlay(var state) = model else {
                throw Failure.notReadyToPlay
            }
            guard state.isPlaying else {
                throw Failure.notPlaying
            }
            state.currentTime = state.duration
            state.isPlaying = false
            model = .readyToPlay(state)
        case .playerDidUpdateCurrentTime(let currentTime):
            guard case .readyToPlay(var state) = model else {
                throw Failure.notReadyToPlay
            }
            state.currentTime = currentTime
            model = .readyToPlay(state)
        case .playerDidFailToBecomeReady:
            guard case .waitingForPlayerToBecomeReadyToPlayURL(let url) = model else {
                throw Failure.notWaitingToBecomeReadyToPlay
            }
            model = .readyToLoadURL(url)
            perform(.showAlert(text: "Unable to load media", button: "OK"))
        }
    }

    public static func view(for model: Model) -> View {
        switch model {
        case .waitingForURL:
             return View(
                playPauseButtonMode: .play,
                isPlayPauseButtonEnabled: false,
                areSeekButtonsHidden: true,
                playbackTime: "",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false,
                isLoadingIndicatorVisible: false
            )
        case .readyToLoadURL:
            return View(
                playPauseButtonMode: .play,
                isPlayPauseButtonEnabled: true,
                areSeekButtonsHidden: true,
                playbackTime: "",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false,
                isLoadingIndicatorVisible: false
            )
        case .waitingForPlayerToBecomeReadyToPlayURL:
            return View(
                playPauseButtonMode: .pause,
                isPlayPauseButtonEnabled: true,
                areSeekButtonsHidden: true,
                playbackTime: "",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false,
                isLoadingIndicatorVisible: true
            )
        case .readyToPlay(let state):
            var remainingTime: TimeInterval? {
                guard let currentTime = state.currentTime else { return nil }
                return state.duration - currentTime
            }
            var remainingTimeText: String {
                guard let remainingTime = remainingTime else { return "" }
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute, .second]
                formatter.zeroFormattingBehavior = .pad
                return "-" + formatter.string(from: remainingTime)!
            }
            var isPlayPauseButtonEnabled: Bool {
                guard let remainingTime = remainingTime else { return true }
                return remainingTime > 0
            }
            var isSeekBackButtonEnabled: Bool {
                guard let currentTime = state.currentTime else { return false }
                return currentTime > 0
            }
            var isSeekForwardButtonEnabled: Bool {
                guard let remainingTime = remainingTime else { return false }
                return remainingTime > 0
            }
            return View(
                playPauseButtonMode: state.isPlaying ? .pause : .play,
                isPlayPauseButtonEnabled: isPlayPauseButtonEnabled,
                areSeekButtonsHidden: false,
                playbackTime: remainingTimeText,
                isSeekBackButtonEnabled: isSeekBackButtonEnabled,
                isSeekForwardButtonEnabled: isSeekForwardButtonEnabled,
                isLoadingIndicatorVisible: state.isPlaying && state.currentTime == nil
            )
        }
    }

}
