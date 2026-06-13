import Foundation

final class SplashViewModel {

    private let sessionRepository:
        SessionRepository

    init(
        sessionRepository: SessionRepository
    ) {
        self.sessionRepository =
            sessionRepository
    }

    func hasPreviousSession()
    async throws -> Bool {

        try await sessionRepository
            .fetchLatest() != nil
    }

    func fetchLatestSession()
    async throws -> Session? {

        try await sessionRepository
            .fetchLatest()
    }

    func createNewSession(
        vehicleCount: Int
    ) async throws -> Session {

        let session =
            Session(
                id: UUID(),
                name:
                    "Vehicle Tracking Session",
                status:
                    SessionStatus
                        .created
                        .rawValue,
                vehicleCount:
                    vehicleCount,
                createdAt: .now,
                updatedAt: .now
            )

        try await sessionRepository
            .create(
                session: session
            )

        return session
    }
}
