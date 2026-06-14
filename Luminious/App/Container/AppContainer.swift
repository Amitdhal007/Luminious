import Foundation

final class AppContainer {

    let locationManager: LocationProviding
    let eventBus: AppEventDispatching
    let coreDataStack: CoreDataContextProvider

    let sessionRepository: SessionRepository
    let vehicleRepository: VehicleRepository
    let routeRepository: RouteRepository

    let sessionBootstrapService: SessionBootstrapService

    let vehicleSimulationService: VehicleSimulationService

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

    static func makeDefault() -> AppContainer {

        let locationManager = LocationManager()
        let eventBus = AppEventBus()
        let coreDataStack = CoreDataStack()

        let sessionRepository =
            SessionRepositoryImpl(
                contextProvider: coreDataStack
            )

        let vehicleRepository =
            VehicleRepositoryImpl(
                contextProvider: coreDataStack
            )

        let routeRepository =
            RouteRepositoryImpl(
                contextProvider: coreDataStack
            )
        
        let driverRepository = DefaultDriverGenerationService()
        let reverseGeocoder = ReverseGeocoder()
        let geoCoding = GeocodingService(geocoder: reverseGeocoder)
        let defaultRouteGeneratorRepostiory = DefaultRouteGenerationService(geocodingService: geoCoding)

        let sessionBootstrapService =
        DefaultSessionBootstrapService(
                vehicleRepository: vehicleRepository,
                routeRepository: routeRepository,
                driverGenerator: driverRepository,
                routeGenerator: defaultRouteGeneratorRepostiory
            )

        let vehicleSimulationService =
            DefaultVehicleSimulationService(
                vehicleRepository: vehicleRepository,
                routeRepository: routeRepository
            )

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
