import Foundation

/// Container holding all dependencies required by Map module.
/// This prevents constructor explosion and improves scalability/testability.
struct MapDependencies {

    // MARK: - Repositories

    let sessionRepository: SessionRepository
    let vehicleRepository: VehicleRepository
    let routeRepository: RouteRepository

    // MARK: - Services

    let locationManager: LocationProviding
    let vehicleSimulationService: VehicleSimulationService
    let sessionBootstrapService: SessionBootstrapService

    // MARK: - App Infrastructure

    let eventBus: AppEventDispatching
    let toast: ToastPresenting
    let loader: LoaderPresenting
}
