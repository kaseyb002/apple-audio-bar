import Foundation
import Elm

struct InvalidTransitionError: Error {}

struct AudioBarModule: ElmModule {

    //
    // MARK: -
    // MARK: Message
    //

    enum Message {

        case prepareToLoad(URL)
        case togglePlay
        case seekBack
        case seekForward

        case playerDidUpdateDuration(TimeInterval)
        case playerDidUpdateCurrentTime(TimeInterval)

    }

    //
    // MARK: -
    // MARK: Model
    //

    enum Model: Initable {

        struct ReadyState {
            var isPlaying: Bool
            var duration: TimeInterval
            var currentTime: TimeInterval
        }

        case waitingForURL
        case readyToLoad(URL)
        case waitingForDuration
        case readyToPlay(ReadyState)

        init() { self = .waitingForURL }

    }

    //
    // MARK: -
    // MARK: Command
    //

    enum Command {

        enum Player {
            case open(URL)
            case play
            case pause
            case setCurrentTime(TimeInterval)
        }

        case player(Player)

    }

    //
    // MARK: -
    // MARK: View
    //

    struct View {

        public enum PlayPauseButtonMode { case play, pause }

        let playPauseButtonMode: PlayPauseButtonMode // Rename to match togglePlay
        let isPlayPauseButtonEnabled: Bool
        let areSeekButtonsHidden: Bool
        let playbackTime: String

        let isSeekBackButtonEnabled: Bool
        let isSeekForwardButtonEnabled: Bool

    }

    //
    // MARK: -
    // MARK: Update
    //

    static func update(for message: Message, model: inout Model) throws -> [Command] {

        switch message {

        case .prepareToLoad(let url):
            model = .readyToLoad(url)
            return []

        case .togglePlay:
            switch model {
            case .waitingForURL:
                throw InvalidTransitionError()
            case .readyToLoad(at: let url):
                model = .waitingForDuration
                return [.player(.open(url))]
            case .waitingForDuration:
                throw InvalidTransitionError()
            case .readyToPlay(var state):
                let command: Command = .player(state.isPlaying ? .pause : .play)
                state.isPlaying = !state.isPlaying
                model = .readyToPlay(state)
                return [command]
            }

        case .playerDidUpdateDuration(let duration):
            guard case .waitingForDuration = model else {
                throw InvalidTransitionError()
            }
            model = .readyToPlay(.init(isPlaying: true, duration: duration, currentTime: 0))
            return [.player(.play)]

        case .playerDidUpdateCurrentTime(let currentTime):
            guard case .readyToPlay(var state) = model else {
                throw InvalidTransitionError()
            }
            guard currentTime >= 0, currentTime <= state.duration else {
                throw InvalidTransitionError()
            }
            state.currentTime = currentTime

            var commands: [Command] = []
            if state.currentTime == state.duration && state.isPlaying {
                state.isPlaying = false
                commands.append(.player(.pause))
            }

            model = .readyToPlay(state)
            return commands

        case .seekBack:
            guard case .readyToPlay(var state) = model else {
                throw InvalidTransitionError()
            }
            state.currentTime = max(0, state.currentTime - 15)
            model = .readyToPlay(state)
            return [.player(.setCurrentTime(state.currentTime))]

        case .seekForward:
            guard case .readyToPlay(var state) = model else {
                throw InvalidTransitionError()
            }
            var commands: [Command] = []
            state.currentTime = min(state.duration, state.currentTime + 15)
            commands.append(.player(.setCurrentTime(state.currentTime)))
            if state.currentTime == state.duration && state.isPlaying {
                state.isPlaying = false
                commands.append(.player(.pause))
            }
            model = .readyToPlay(state)
            return commands
        }

    }

//    // Temporary
//    static var invalidTransitionError: Error {
//        return InvalidTransitionError()
//    }

    static func view(for model: Model) -> View {
        switch model {
        case .waitingForURL:
             return View(
                playPauseButtonMode: .play,
                isPlayPauseButtonEnabled: false,
                areSeekButtonsHidden: true,
                playbackTime: "",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false
            )
        case .readyToLoad:
            return View(
                playPauseButtonMode: .play,
                isPlayPauseButtonEnabled: true,
                areSeekButtonsHidden: true,
                playbackTime: "",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false
            )
        case .waitingForDuration:
            return View(
                playPauseButtonMode: .play,
                isPlayPauseButtonEnabled: false,
                areSeekButtonsHidden: true,
                playbackTime: "Loading",
                isSeekBackButtonEnabled: false,
                isSeekForwardButtonEnabled: false
            )
        case .readyToPlay(let state):

            let remainingTime = state.duration - state.currentTime
            var remainingTimeText: String {
                let formatter = DateComponentsFormatter()
                formatter.allowedUnits = [.minute, .second]
                formatter.zeroFormattingBehavior = .pad
                return "-" + formatter.string(from: remainingTime)!
            }

            return View(
                playPauseButtonMode: state.isPlaying ? .pause : .play,
                isPlayPauseButtonEnabled: remainingTime > 0,
                areSeekButtonsHidden: false,
                playbackTime: remainingTimeText,
                isSeekBackButtonEnabled: state.currentTime > 0,
                isSeekForwardButtonEnabled: remainingTime > 0
            )

        }

    }

}
