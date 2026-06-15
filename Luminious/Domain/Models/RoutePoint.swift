import Foundation

final class RoutePoint {

    let id: UUID

    let latitude: Double

    let longitude: Double

    let heading: Double

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
