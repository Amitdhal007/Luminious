import Foundation

/// Represents the playback state of a vehicle/session timeline.
///
/// Design intent:
/// - Immutable snapshot model
/// - Prevents accidental state mutation
/// - Safe for concurrency and reactive pipelines
struct PlaybackState {

    let id: UUID
    let currentPointIndex: Int
    let isPlaying: Bool
    let playbackSpeed: Double
    let updatedAt: Date

    init(
        id: UUID,
        currentPointIndex: Int,
        isPlaying: Bool,
        playbackSpeed: Double,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.currentPointIndex = currentPointIndex
        self.isPlaying = isPlaying
        self.playbackSpeed = playbackSpeed
        self.updatedAt = updatedAt
    }
}
