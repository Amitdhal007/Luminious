import UIKit

final class DefaultMapFactory: MapFactory {

    private let sessionRepository:
        SessionRepository

    private let vehicleRepository:
        VehicleRepository

    private let routeRepository:
        RouteRepository

    private let locationManager:
        LocationProviding

    private let eventBus:
        AppEventDispatching

    private let toast:
        ToastPresenting

    private let vehicleSimulationService:
        VehicleSimulationService

    init(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        locationManager: LocationProviding,
        eventBus: AppEventDispatching,
        toast: ToastPresenting,
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

        self.toast =
            toast

        self.vehicleSimulationService =
            vehicleSimulationService
    }
}
extension DefaultMapFactory {

    func makeMapScreen(
        coordinator: MapCoordinating
    ) -> MapVC {

        let vc =
            MapVC.getVC(
                from: .map
            )

        vc.coordinator =
            coordinator

        vc.toast =
            toast

        vc.viewModel =
            MapViewModel(
                sessionRepository:
                    sessionRepository,
                vehicleRepository:
                    vehicleRepository,
                routeRepository:
                    routeRepository,
                locationManager:
                    locationManager,
                eventBus:
                    eventBus,
                vehicleSimulationService:
                    vehicleSimulationService
            )

        return vc
    }
}
extension DefaultMapFactory {

    func makeSearchVehicleScreen(
        vehicles: [Vehicle]
    ) -> SearchVehicleVC {

        let vc =
        SearchVehicleVC.getVC(from: .map)

        vc.viewModel =
            SearchVehicleViewModel(
                vehicles: vehicles,
                eventBus: eventBus
            )

        return vc
    }
}
