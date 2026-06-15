import Combine
import CoreLocation
import Foundation

final class MapViewModel {

    // MARK: - State

    private(set) var vehicles: [Vehicle] = []

    @Published private(set) var currentSession: Session?
    
    internal var annotationMap: [UUID: VehicleAnnotation] = [:]

    // MARK: - Dependencies

    private let sessionRepository: SessionRepository
    private let vehicleRepository: VehicleRepository
    private let routeRepository: RouteRepository
    let locationManager: LocationProviding
    let eventBus: AppEventDispatching
    private let simulationService: VehicleSimulationService
    private let sessionBootstrapService: SessionBootstrapService

    // MARK: - Publishers

    var vehiclesPublisher: AnyPublisher<[Vehicle], Never> {
        simulationService.vehiclesPublisher
    }

    // MARK: - Init

    init(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        locationManager: LocationProviding,
        eventBus: AppEventDispatching,
        vehicleSimulationService: VehicleSimulationService,
        sessionBootstrapService: SessionBootstrapService
    ) {
        self.sessionRepository = sessionRepository
        self.vehicleRepository = vehicleRepository
        self.routeRepository = routeRepository
        self.locationManager = locationManager
        self.eventBus = eventBus
        self.simulationService = vehicleSimulationService
        self.sessionBootstrapService = sessionBootstrapService
    }
    
    public func setVehicles(_ vehicles: [Vehicle]) {
        self.vehicles = vehicles
    }
    
    public func updateCurrentSession(_ session: Session?) {
        self.currentSession = session
    }
}
extension MapViewModel {

    func fetchCurrentSession() async throws -> Session? {
        let session = try await sessionRepository.fetchLatest()
        self.currentSession = session
        return session
    }

    func createNewSession(vehicleCount: Int) async throws -> Session {

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

        try await sessionRepository.create(session: session)

        self.currentSession = session

        return session
    }
}
extension MapViewModel {

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
extension MapViewModel {

    func loadVehicles(sessionId: UUID) async throws -> [Vehicle] {

        let vehicles = try await vehicleRepository.fetchVehicles(
            sessionId: sessionId
        )

        self.vehicles = vehicles

        return vehicles
    }
}
extension MapViewModel {

    func startSimulation(sessionId: UUID) {
        simulationService.start(sessionId: sessionId)
    }

    func stopSimulation() {
        simulationService.stop()
    }
}
extension MapViewModel {

    func startNewSession(vehicleCount: Int) async throws {

        guard
            let location = locationManager.currentLocation?.coordinate
        else {
            return
        }

        let session = try await createNewSession(vehicleCount: vehicleCount)

        try await bootstrapSession(
            session,
            userLocation: location
        )

        startSimulation(sessionId: session.id)
    }
}
