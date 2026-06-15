import CoreData

enum VehicleMapper {

    static func toDomain(
        entity: VehicleEntity
    ) -> Vehicle {

        guard
            let id = entity.id,
            let driverName = entity.driverName,
            let vehicleNumber = entity.vehicleNumber,
            let vehicleTypeString = entity.vehicleType,
            let updatedAt = entity.updatedAt
        else {
            fatalError(
                "Invalid VehicleEntity state"
            )
        }

        return Vehicle(
            id: id,
            driverName: driverName,
            driverAvatarURL: .init(string: entity.driverAvatarURL ?? ""),
            vehicleNumber: vehicleNumber,
            vehicleType:
                VehicleType(
                    rawValue: vehicleTypeString
                ) ?? .sedan,
            rating: entity.rating,
            currentLatitude: entity.currentLatitude,
            currentLongitude: entity.currentLongitude,
            currentHeading: entity.currentHeading,
            currentRouteIndex:
                Int(entity.currentRouteIndex),
            isActive: entity.isActive,
            updatedAt: updatedAt
        )
    }

    static func updateEntity(
        _ entity: VehicleEntity,
        with vehicle: Vehicle
    ) {

        entity.id = vehicle.id
        entity.driverName = vehicle.driverName
        entity.driverAvatarURL = vehicle.driverAvatarURL?.absoluteString
        entity.vehicleNumber = vehicle.vehicleNumber
        entity.vehicleType = vehicle.vehicleType.rawValue
        entity.rating = vehicle.rating
        entity.currentLatitude = vehicle.currentLatitude
        entity.currentLongitude = vehicle.currentLongitude
        entity.currentHeading = vehicle.currentHeading
        entity.currentRouteIndex = Int32(vehicle.currentRouteIndex)
        entity.isActive = vehicle.isActive
        entity.updatedAt = vehicle.updatedAt
    }
}
