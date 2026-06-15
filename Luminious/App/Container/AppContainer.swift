import Foundation

/// AppContainer acts as the Composition Root of the application.
///
/// Responsibility:
/// - Centralizes dependency creation and wiring
/// - Ensures a single source of truth for service initialization
/// - Prevents service locator pattern misuse
///
/// Assumptions:
/// - AppContainer is created once at app startup
/// - All dependencies are long-lived singletons within app scope
/// - No runtime swapping of implementations is required
final class AppContainer {

    // MARK: - Core System Services

    let locationManager: LocationProviding
    let eventBus: AppEventDispatching
    let coreDataStack: CoreDataContextProvider

    // MARK: - Repositories

    let sessionRepository: SessionRepository
    let vehicleRepository: VehicleRepository
    let routeRepository: RouteRepository

    // MARK: - Domain Services

    let sessionBootstrapService: SessionBootstrapService
    let vehicleSimulationService: VehicleSimulationService

    // MARK: - Init

    init(
        eventBus: AppEventDispatching,
        locationManager: LocationProviding,
        coreDataStack: CoreDataContextProvider,
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        sessionBootstrapService: SessionBootstrapService,
        vehicleSimulationService: VehicleSimulationService
    ) {
        self.eventBus = eventBus
        self.locationManager = locationManager
        self.coreDataStack = coreDataStack

        self.sessionRepository = sessionRepository
        self.vehicleRepository = vehicleRepository
        self.routeRepository = routeRepository

        self.sessionBootstrapService = sessionBootstrapService
        self.vehicleSimulationService = vehicleSimulationService
    }
}
extension AppContainer {

    /// Builds the default application dependency graph.
    ///
    /// This method acts as the Composition Root for the app.
    /// All concrete implementations are initialized here and injected
    /// into higher-level services.
    ///
    /// Assumptions:
    /// - No dependency injection framework is used (manual DI only)
    /// - All services are stateless or safely retained for app lifecycle
    static func makeDefault() -> AppContainer {

        // MARK: - Core Infrastructure

        let locationManager = LocationManager()
        let eventBus = AppEventBus()
        let coreDataStack = CoreDataStack()

        // MARK: - Repositories

        let sessionRepository = SessionRepositoryImpl(
            contextProvider: coreDataStack
        )

        let vehicleRepository = VehicleRepositoryImpl(
            contextProvider: coreDataStack
        )

        let routeRepository = RouteRepositoryImpl(
            contextProvider: coreDataStack
        )

        // MARK: - Domain Generators / Services

        let driverGenerator = DefaultDriverGenerationService()

        let reverseGeocoder = ReverseGeocoder()
        let geoCodingService = GeocodingService(
            geocoder: reverseGeocoder
        )

        let routeGenerator = DefaultRouteGenerationService(
            geocodingService: geoCodingService
        )

        // MARK: - Business Services

        let sessionBootstrapService = DefaultSessionBootstrapService(
            vehicleRepository: vehicleRepository,
            routeRepository: routeRepository,
            driverGenerator: driverGenerator,
            routeGenerator: routeGenerator
        )

        let vehicleSimulationService = DefaultVehicleSimulationService(
            vehicleRepository: vehicleRepository,
            routeRepository: routeRepository,
            sessionRepository: sessionRepository
        )

        // MARK: - Container Assembly

        return AppContainer(
            eventBus: eventBus,
            locationManager: locationManager,
            coreDataStack: coreDataStack,
            sessionRepository: sessionRepository,
            vehicleRepository: vehicleRepository,
            routeRepository: routeRepository,
            sessionBootstrapService: sessionBootstrapService,
            vehicleSimulationService: vehicleSimulationService
        )
    }
}
