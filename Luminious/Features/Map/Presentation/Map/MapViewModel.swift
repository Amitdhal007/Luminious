import Combine
import Foundation

final class MapViewModel {

    // MARK: - Published State

    var vehicles: [Vehicle] = []

    // MARK: - Dependencies

    private let sessionRepository: SessionRepository

    private let vehicleRepository: VehicleRepository

    private let routeRepository: RouteRepository

    let locationManager: LocationProviding

    let eventBus: AppEventDispatching

    private let simulationService:
        VehicleSimulationService

    // MARK: - Publishers

    var vehiclesPublisher:
        AnyPublisher<[Vehicle], Never> {

        simulationService
            .vehiclesPublisher
    }

    // MARK: - Init

    init(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        locationManager: LocationProviding,
        eventBus: AppEventDispatching,
        vehicleSimulationService: VehicleSimulationService
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

        self.simulationService =
            vehicleSimulationService
    }
}

// MARK: - Session

extension MapViewModel {

    func fetchCurrentSession()
    async throws -> Session? {

        try await sessionRepository
            .fetchLatest()
    }
}

// MARK: - Vehicles

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

// MARK: - Simulation Control

extension MapViewModel {

    func startSimulation(
        sessionId: UUID
    ) {

        simulationService.start(
            sessionId: sessionId
        )
    }

    func stopSimulation() {

        simulationService.stop()
    }
}
