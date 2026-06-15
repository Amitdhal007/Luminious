import Foundation

/// Represents a vehicle in the tracking/simulation system.
///
/// Design intent:
/// - Holds current state of a moving vehicle
/// - Updated by simulation or tracking engine
/// - Maintains consistency of position + route progress
final class Vehicle: Identifiable {

    let id: UUID
    let driverName: String
    let driverAvatarURL: URL?
    let vehicleNumber: String
    let vehicleType: VehicleType
    let rating: Double

    var currentLatitude: Double
    var currentLongitude: Double
    var currentHeading: Double
    var currentRouteIndex: Int

    var isActive: Bool
    var updatedAt: Date

    init(
        id: UUID,
        driverName: String,
        driverAvatarURL: URL?,
        vehicleNumber: String,
        vehicleType: VehicleType,
        rating: Double,
        currentLatitude: Double,
        currentLongitude: Double,
        currentHeading: Double,
        currentRouteIndex: Int,
        isActive: Bool,
        updatedAt: Date
    ) {
        self.id = id
        self.driverName = driverName
        self.driverAvatarURL = driverAvatarURL
        self.vehicleNumber = vehicleNumber
        self.vehicleType = vehicleType
        self.rating = rating
        self.currentLatitude = currentLatitude
        self.currentLongitude = currentLongitude
        self.currentHeading = currentHeading
        self.currentRouteIndex = currentRouteIndex
        self.isActive = isActive
        self.updatedAt = updatedAt
    }
}
extension Vehicle {

    /// Activates the vehicle for tracking/simulation
    func activate() {
        isActive = true
        updatedAt = Date()
    }

    /// Updates vehicle position from simulation or GPS feed
    func updatePosition(
        latitude: Double,
        longitude: Double,
        heading: Double,
        routeIndex: Int
    ) {
        currentLatitude = latitude
        currentLongitude = longitude
        currentHeading = heading
        currentRouteIndex = routeIndex
        updatedAt = Date()
    }

    /// Deactivates vehicle tracking
    func deactivate() {
        isActive = false
        updatedAt = Date()
    }
}
