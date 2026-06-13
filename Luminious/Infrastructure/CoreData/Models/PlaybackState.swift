import Foundation

final class PlaybackState {

    let id: UUID

    var currentPointIndex: Int

    var isPlaying: Bool

    var playbackSpeed: Double

    var updatedAt: Date

    init(
        id: UUID,
        currentPointIndex: Int,
        isPlaying: Bool,
        playbackSpeed: Double,
        updatedAt: Date
    ) {
        self.id = id
        self.currentPointIndex = currentPointIndex
        self.isPlaying = isPlaying
        self.playbackSpeed = playbackSpeed
        self.updatedAt = updatedAt
    }
}
