import Foundation

import Foundation

final class AppContainer {

    let locationManager: LocationProviding

    let eventBus: AppEventDispatching

    let coreDataStack: CoreDataContextProvider

    let sessionRepository: SessionRepository

    let vehicleRepository: VehicleRepository

    let routeRepository: RouteRepository

    init(
        eventBus: AppEventDispatching,
        locationManager: LocationProviding,
        coreDataStack: CoreDataContextProvider,
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository
    ) {

        self.eventBus = eventBus
        self.locationManager = locationManager
        self.coreDataStack = coreDataStack
        self.sessionRepository = sessionRepository
        self.vehicleRepository = vehicleRepository
        self.routeRepository = routeRepository
    }
}
extension AppContainer {

    static func makeDefault() -> AppContainer {

        let locationManager =
            LocationManager()

        let eventBus =
            AppEventBus()

        let coreDataStack =
            CoreDataStack()

        let sessionRepository =
            SessionRepositoryImpl(
                contextProvider:
                    coreDataStack
            )

        let vehicleRepository =
            VehicleRepositoryImpl(
                contextProvider:
                    coreDataStack
            )

        let routeRepository =
            RouteRepositoryImpl(
                contextProvider:
                    coreDataStack
            )

        return AppContainer(
            eventBus: eventBus,
            locationManager:
                locationManager,
            coreDataStack:
                coreDataStack,
            sessionRepository:
                sessionRepository,
            vehicleRepository:
                vehicleRepository,
            routeRepository:
                routeRepository
        )
    }
}
