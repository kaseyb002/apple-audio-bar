import MediaPlayer

extension MPNowPlayingInfoCenter {

    // MARK: Set elapsed playback time

    func setElapsedPlaybackTime(_ elapsedPlaybackTime: TimeInterval) {
        guard needsSetElapsedPlaybackTime(elapsedPlaybackTime) else { return }
        forceSetElapsedPlaybackTime(elapsedPlaybackTime)
    }

    private func needsSetElapsedPlaybackTime(_ elapsedPlaybackTime: TimeInterval) -> Bool {
        return nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] as? TimeInterval != elapsedPlaybackTime
    }

    private func forceSetElapsedPlaybackTime(_ elapsedPlaybackTime: TimeInterval) {
        nowPlayingInfo![MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
    }

    // MARK: Set playback duration

    func setPlaybackDuration(_ playbackDuration: TimeInterval) {
        guard needsSetPlaybackDuration(playbackDuration) else { return }
        forceSetPlaybackDuration(playbackDuration)
    }

    private func needsSetPlaybackDuration(_ playbackDuration: TimeInterval) -> Bool {
        return nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] as? TimeInterval != playbackDuration
    }

    private func forceSetPlaybackDuration(_ playbackDuration: TimeInterval) {
        nowPlayingInfo![MPMediaItemPropertyPlaybackDuration] = playbackDuration
    }

}
