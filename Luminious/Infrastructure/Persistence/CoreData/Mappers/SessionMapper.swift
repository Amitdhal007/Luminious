import Foundation

enum SessionMapper {

    static func toDomain(
        entity: SessionEntity
    ) -> Session {

        guard
            let id = entity.id,
            let name = entity.name,
            let status = SessionStatus(rawValue: entity.status),
            let createdAt = entity.createdAt,
            let updatedAt = entity.updatedAt
        else {
            fatalError(
                "Invalid SessionEntity state"
            )
        }

        return Session(
            id: id,
            name: name,
            status: status,
            vehicleCount: Int(entity.vehicleCount),
            createdAt: createdAt,
            updatedAt: updatedAt,
            tripStartedAt: entity.tripStartedAt,
            tripEndedAt: entity.tripEndedAt
        )
    }

    static func updateEntity(
        _ entity: SessionEntity,
        with session: Session
    ) {

        entity.id = session.id
        entity.name = session.name
        entity.status = session.status.rawValue
        entity.vehicleCount =
            Int32(session.vehicleCount)

        entity.createdAt =
            session.createdAt

        entity.updatedAt =
            session.updatedAt

        // MARK: - Trip Lifecycle

        entity.tripStartedAt =
            session.tripStartedAt

        entity.tripEndedAt =
            session.tripEndedAt
    }
}
