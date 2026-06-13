import Combine
import Foundation

final class MapViewModel {

    // MARK: - Published State

    private(set) var vehicles: [Vehicle] = []
    
    // MARK: - Dependencies

    private let sessionRepository: SessionRepository

    private let vehicleRepository: VehicleRepository

    private let routeRepository: RouteRepository

    let locationManager: LocationProviding

    let eventBus: AppEventDispatching

    // MARK: - Init

    init(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        locationManager: LocationProviding,
        eventBus: AppEventDispatching
    ) {

        self.sessionRepository =
            sessionRepository

        self.vehicleRepository =
            vehicleRepository

        self.routeRepository =
            routeRepository

        self.locationManager =
            locationManager

        self.eventBus =
            eventBus
    }
}

extension MapViewModel {

    func fetchCurrentSession()
    async throws -> Session? {

        try await sessionRepository
            .fetchLatest()
    }
}

extension MapViewModel {

    func loadVehicles(
        sessionId: UUID
    ) async throws -> [Vehicle] {

        let vehicles =
            try await vehicleRepository
            .fetchVehicles(
                sessionId: sessionId
            )

        self.vehicles =
            vehicles
        
        return vehicles
    }
}
