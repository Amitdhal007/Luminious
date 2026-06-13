import CoreData

final class SessionRepositoryImpl:
    SessionRepository {

    private let contextProvider:
        CoreDataContextProvider

    init(
        contextProvider: CoreDataContextProvider
    ) {
        self.contextProvider =
            contextProvider
    }
}

extension SessionRepositoryImpl {

    func create(
        session: Session
    ) async throws {

        let context =
            contextProvider
                .newBackgroundContext()

        try await context.performAsync {

            let entity =
                SessionEntity(
                    context: context
                )

            SessionMapper.updateEntity(
                entity,
                with: session
            )

            try context.save()
        }
    }
}

extension SessionRepositoryImpl {

    func fetchLatest()
    async throws -> Session? {

        let request:
            NSFetchRequest<SessionEntity> =
                SessionEntity.fetchRequest()

        request.fetchLimit = 1

        request.sortDescriptors = [
            NSSortDescriptor(
                key: #keyPath(
                    SessionEntity.updatedAt
                ),
                ascending: false
            )
        ]

        guard let entity =
            try contextProvider
                .viewContext
                .fetch(request)
                .first
        else {
            return nil
        }

        return SessionMapper
            .toDomain(
                entity: entity
            )
    }
}

extension SessionRepositoryImpl {

    func update(
        session: Session
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
                    session.id as CVarArg
                )

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .sessionNotFound
            }

            SessionMapper.updateEntity(
                entity,
                with: session
            )

            try context.save()
        }
    }
}

extension SessionRepositoryImpl {

    func delete(
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

            guard let entity =
                try context.fetch(request)
                    .first
            else {
                throw RepositoryError
                    .sessionNotFound
            }

            context.delete(entity)

            try context.save()
        }
    }
}
