import Foundation

/// Represents a single point in a route used for navigation or playback.
///
/// This is a reference type because:
/// - It may be shared across simulation, playback, and persistence layers
/// - Updates (if any) should reflect globally across references
/// - It can be extended later with mutable metadata (e.g., visited state, timestamps)
final class RoutePoint {

    /// Unique identifier used for persistence or diffing
    let id: UUID

    /// Latitude in degrees (-90 to 90)
    let latitude: Double

    /// Longitude in degrees (-180 to 180)
    let longitude: Double

    /// Heading in degrees (0–360), where 0 represents North
    let heading: Double

    /// Sequence index defining order in route playback
    let sequence: Int

    init(
        id: UUID = UUID(),
        latitude: Double,
        longitude: Double,
        heading: Double,
        sequence: Int
    ) {
        self.id = id
        self.latitude = latitude
        self.longitude = longitude
        self.heading = heading
        self.sequence = sequence
    }
}
