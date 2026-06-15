import UIKit

/// Factory responsible for constructing all Map module screens.
///
/// Responsibilities:
/// - Inject dependencies into ViewControllers
/// - Build ViewModels
/// - Keep Coordinator free from object creation logic
final class DefaultMapFactory: MapFactory {

    // MARK: - Dependencies

    private let dependencies: MapDependencies

    // MARK: - Init

    init(dependencies: MapDependencies) {
        self.dependencies = dependencies
    }
}
extension DefaultMapFactory {

    /// Creates the main Map screen with fully injected dependencies.
    func makeMapScreen(
        coordinator: MapCoordinating
    ) -> UIViewController {

        let vc = MapVC.getVC(from: .map)

        // MARK: - Coordinator Injection
        vc.coordinator = coordinator

        // MARK: - UI Utilities
        vc.toast = dependencies.toast
        vc.loader = dependencies.loader

        // MARK: - ViewModel Composition
        vc.viewModel = MapViewModel(
            sessionRepository: dependencies.sessionRepository,
            vehicleRepository: dependencies.vehicleRepository,
            routeRepository: dependencies.routeRepository,
            locationManager: dependencies.locationManager,
            eventBus: dependencies.eventBus,
            vehicleSimulationService: dependencies.vehicleSimulationService,
            sessionBootstrapService: dependencies.sessionBootstrapService
        )

        return vc
    }
}
extension DefaultMapFactory {

    /// Creates vehicle search screen used in Map flow.
    func makeSearchVehicleScreen(
        vehicles: [Vehicle],
    ) -> UIViewController {

        let vc = SearchVehicleVC.getVC(from: .map)

        vc.viewModel = SearchVehicleViewModel(
            vehicles: vehicles,
            eventBus: dependencies.eventBus
        )

        return vc
    }
}
extension DefaultMapFactory {

    /// Creates vehicle details screen with session context.
    func makeVehicleDetailsScreen(
        session: Session,
        vehicle: Vehicle
    ) -> UIViewController {

        let vc = VehicleDetailsVC.getVC(from: .map)

        // MARK: - UI Dependencies
        vc.toast = dependencies.toast

        // MARK: - ViewModel Composition
        vc.viewModel = VehicleDetailsViewModel(
            vehicle: vehicle,
            session: session,
            routeRepository: dependencies.routeRepository,
            vehicleRepository: dependencies.vehicleRepository
        )

        return vc
    }
}
