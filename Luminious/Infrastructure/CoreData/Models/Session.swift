import Foundation

final class Session {

    let id: UUID

    let name: String

    var status: Int16

    var vehicleCount: Int

    let createdAt: Date

    var updatedAt: Date

    init(
        id: UUID,
        name: String,
        status: Int16,
        vehicleCount: Int,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.vehicleCount = vehicleCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
