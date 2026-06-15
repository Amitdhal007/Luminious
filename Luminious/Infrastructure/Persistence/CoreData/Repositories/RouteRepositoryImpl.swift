import CoreData

final class RouteRepositoryImpl:
    RouteRepository {

    private let contextProvider:
        CoreDataContextProvider

    init(
        contextProvider: CoreDataContextProvider
    ) {
        self.contextProvider =
            contextProvider
    }
}

extension RouteRepositoryImpl {

    func create(
        route: Route,
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

            guard let vehicle =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .vehicleNotFound
            }

            let routeEntity =
                RouteEntity(
                    context: context
                )

            RouteMapper.updateEntity(
                routeEntity,
                with: route
            )

            routeEntity.vehicle =
                vehicle

            for point in route.routePoints {

                let pointEntity =
                    RoutePointEntity(
                        context: context
                    )

                RoutePointMapper
                    .updateEntity(
                        pointEntity,
                        with: point
                    )

                pointEntity.route =
                    routeEntity
            }

            try context.save()
        }
    }
}

extension RouteRepositoryImpl {

    func fetchRoute(
        vehicleId: UUID
    ) async throws -> Route? {

        let request:
            NSFetchRequest<RouteEntity> =
                RouteEntity.fetchRequest()

        request.fetchLimit = 1

        request.predicate =
            NSPredicate(
                format: "vehicle.id == %@",
                vehicleId as CVarArg
            )

        guard let entity =
            try contextProvider
                .viewContext
                .fetch(request)
                .first
        else {
            return nil
        }

        return RouteMapper.toDomain(
            entity: entity
        )
    }
}

extension RouteRepositoryImpl {

    func update(
        route: Route
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let request:
                NSFetchRequest<RouteEntity> =
                    RouteEntity.fetchRequest()

            request.fetchLimit = 1

            request.predicate =
                NSPredicate(
                    format: "id == %@",
                    route.id as CVarArg
                )

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                return
            }

            RouteMapper.updateEntity(
                entity,
                with: route
            )

            let existingPoints =
                (entity.routePoints
                    as? Set<RoutePointEntity>)
                ?? []

            existingPoints.forEach {
                context.delete($0)
            }

            for point in route.routePoints {

                let pointEntity =
                    RoutePointEntity(
                        context: context
                    )

                RoutePointMapper
                    .updateEntity(
                        pointEntity,
                        with: point
                    )

                pointEntity.route =
                    entity
            }

            try context.save()
        }
    }
}

extension RouteRepositoryImpl {

    func delete(
        routeId: UUID
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let request:
                NSFetchRequest<RouteEntity> =
                    RouteEntity.fetchRequest()

            request.fetchLimit = 1

            request.predicate =
                NSPredicate(
                    format: "id == %@",
                    routeId as CVarArg
                )

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                return
            }

            context.delete(entity)

            try context.save()
        }
    }
}
