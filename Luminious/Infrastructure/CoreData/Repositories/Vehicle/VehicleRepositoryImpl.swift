import CoreData

final class VehicleRepositoryImpl:
    VehicleRepository {

    private let contextProvider:
        CoreDataContextProvider

    init(
        contextProvider: CoreDataContextProvider
    ) {
        self.contextProvider =
            contextProvider
    }
}

extension VehicleRepositoryImpl {

    func create(
        vehicle: Vehicle,
        sessionId: UUID
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let request:
                NSFetchRequest<SessionEntity> =
                    SessionEntity.fetchRequest()

            request.fetchLimit = 1

            request.predicate =
                NSPredicate(
                    format: "id == %@",
                    sessionId as CVarArg
                )

            guard let session =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .sessionNotFound
            }

            let entity =
                VehicleEntity(
                    context: context
                )

            VehicleMapper.updateEntity(
                entity,
                with: vehicle
            )

            entity.session =
                session

            try context.save()
        }
    }
}

extension VehicleRepositoryImpl {

    func fetchVehicles(
        sessionId: UUID
    ) async throws -> [Vehicle] {

        let request:
            NSFetchRequest<VehicleEntity> =
                VehicleEntity.fetchRequest()

        request.predicate =
            NSPredicate(
                format: "session.id == %@",
                sessionId as CVarArg
            )

        let entities =
            try contextProvider
                .viewContext
                .fetch(request)

        return entities.map {
            VehicleMapper.toDomain(
                entity: $0
            )
        }
    }
}

extension VehicleRepositoryImpl {

    func update(
        vehicle: Vehicle
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let request:
                NSFetchRequest<VehicleEntity> =
                    VehicleEntity.fetchRequest()

            request.fetchLimit = 1

            request.predicate =
                NSPredicate(
                    format: "id == %@",
                    vehicle.id as CVarArg
                )

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .vehicleNotFound
            }

            VehicleMapper.updateEntity(
                entity,
                with: vehicle
            )

            try context.save()
        }
    }
}

extension VehicleRepositoryImpl {

    func delete(
        vehicleId: UUID
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let request:
                NSFetchRequest<VehicleEntity> =
                    VehicleEntity.fetchRequest()

            request.fetchLimit = 1

            request.predicate =
                NSPredicate(
                    format: "id == %@",
                    vehicleId as CVarArg
                )

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .vehicleNotFound
            }

            context.delete(entity)

            try context.save()
        }
    }
}
