import CoreLocation
import Foundation

final class SplashViewModel {

    private let sessionRepository: SessionRepository
    private let sessionBootstrapService: SessionBootstrapService

    let locationProvider: LocationProviding

    init(
        sessionRepository: SessionRepository,
        sessionBootstrapService: SessionBootstrapService,
        locationProvider: LocationProviding
    ) {
        self.sessionRepository = sessionRepository
        self.sessionBootstrapService = sessionBootstrapService
        self.locationProvider = locationProvider
    }

    func hasPreviousSession() async throws -> Bool {
        try await sessionRepository.fetchLatest() != nil
    }

    func fetchLatestSession() async throws -> Session? {
        try await sessionRepository.fetchLatest()
    }

    func createNewSession(
        vehicleCount: Int
    ) async throws -> Session {

        let now = Date()

        let session = Session(
            id: UUID(),
            name: "Vehicle Tracking Session",
            status: .running,
            vehicleCount: vehicleCount,
            createdAt: now,
            updatedAt: now,
            tripStartedAt: now,
            tripEndedAt: nil
        )

        try await sessionRepository.create(
            session: session
        )

        return session
    }

    func bootstrapSession(
        _ session: Session,
        userLocation: CLLocationCoordinate2D
    ) async throws {
        try await sessionBootstrapService.bootstrap(
            session: session,
            userLocation: userLocation
        )
    }
}
