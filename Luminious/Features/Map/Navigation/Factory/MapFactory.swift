import UIKit

/// Factory responsible for creating all Map module screens.
///
/// Ensures:
/// - Dependency injection consistency
/// - Centralized screen configuration
/// - Coordinator-driven navigation setup
protocol MapFactory {

    func makeMapScreen(
        coordinator: MapCoordinating
    ) -> UIViewController

    func makeSearchVehicleScreen(
        vehicles: [Vehicle],
    ) -> UIViewController

    func makeVehicleDetailsScreen(
        session: Session,
        vehicle: Vehicle
    ) -> UIViewController
}
