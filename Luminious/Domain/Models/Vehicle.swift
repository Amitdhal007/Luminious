import Foundation

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
