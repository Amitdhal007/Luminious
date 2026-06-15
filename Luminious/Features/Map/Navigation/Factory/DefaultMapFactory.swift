import UIKit

final class DefaultMapFactory: MapFactory {

    // MARK: - Dependencies

    private let sessionRepository: SessionRepository
    private let vehicleRepository: VehicleRepository
    private let routeRepository: RouteRepository
    private let locationManager: LocationProviding
    private let eventBus: AppEventDispatching
    private let toast: ToastPresenting
    private let loader: LoaderPresenting
    private let vehicleSimulationService: VehicleSimulationService
    private let sessionBootstrapService: SessionBootstrapService

    // MARK: - Init

    init(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        locationManager: LocationProviding,
        eventBus: AppEventDispatching,
        toast: ToastPresenting,
        loader: LoaderPresenting,
        vehicleSimulationService: VehicleSimulationService,
        sessionBootstrapService: SessionBootstrapService
    ) {
        self.sessionRepository = sessionRepository
        self.vehicleRepository = vehicleRepository
        self.routeRepository = routeRepository
        self.locationManager = locationManager
        self.eventBus = eventBus
        self.toast = toast
        self.loader = loader
        self.vehicleSimulationService = vehicleSimulationService
        self.sessionBootstrapService = sessionBootstrapService
    }
}
extension DefaultMapFactory {

    func makeMapScreen(
        coordinator: MapCoordinating
    ) -> MapVC {

        let vc = MapVC.getVC(from: .map)

        vc.coordinator = coordinator
        vc.toast = toast
        vc.loader = loader

        vc.viewModel = MapViewModel(
            sessionRepository: sessionRepository,
            vehicleRepository: vehicleRepository,
            routeRepository: routeRepository,
            locationManager: locationManager,
            eventBus: eventBus,
            vehicleSimulationService: vehicleSimulationService,
            sessionBootstrapService: sessionBootstrapService
        )

        return vc
    }
}
extension DefaultMapFactory {

    func makeSearchVehicleScreen(
        vehicles: [Vehicle]
    ) -> SearchVehicleVC {

        let vc = SearchVehicleVC.getVC(from: .map)

        vc.viewModel = SearchVehicleViewModel(
            vehicles: vehicles,
            eventBus: eventBus
        )

        return vc
    }
}
extension DefaultMapFactory {

    func makeVehicleDetailsScreen(
        session: Session,
        vehicle: Vehicle
    ) -> VehicleDetailsVC {

        let vc = VehicleDetailsVC.getVC(from: .map)

        vc.toast = toast

        vc.viewModel = VehicleDetailsViewModel(
            vehicle: vehicle,
            session: session,
            routeRepository: routeRepository,
            vehicleRepository: vehicleRepository
        )

        return vc
    }
}
