import UIKit

/// Coordinates navigation flow for the Map module.
///
/// Responsibilities:
/// - Launch the main Map screen
/// - Present vehicle search flow
/// - Present vehicle details flow
/// - Handle session completion callback
final class MapCoordinator: Coordinating {

    // MARK: - Dependencies

    /// Factory responsible for creating Map module screens
    private let factory: MapFactory

    /// Navigation controller used for screen transitions
    private let navigationController: UINavigationController

    /// Callback triggered when session finishes
    private let onFinishSession: () -> Void

    // MARK: - Init

    init(
        factory: MapFactory,
        navigationController: UINavigationController,
        onFinishSession: @escaping () -> Void
    ) {
        self.factory = factory
        self.navigationController = navigationController
        self.onFinishSession = onFinishSession
    }

    // MARK: - Start Flow

    /// Starts the Map flow by setting the root view controller.
    func start() {

        let vc = factory.makeMapScreen(coordinator: self)

        navigationController.setViewControllers(
            [vc],
            animated: false
        )
    }
}

// MARK: - MapCoordinating

extension MapCoordinator: MapCoordinating {

    /// Presents vehicle search sheet with available vehicles.
    func mapDidRequestVehicleSearch(vehicles: [Vehicle]) {

        let searchVC = factory.makeSearchVehicleScreen(
            vehicles: vehicles
        )

        configureSheetPresentation(for: searchVC)

        navigationController.present(searchVC, animated: true)
    }

    /// Placeholder for AR flow (not implemented yet)
    func mapDidRequestAR() {
        // Future AR implementation goes here
    }

    /// Called when session ends from Map screen
    func mapDidFinishSession() {
        onFinishSession()
    }

    /// Presents vehicle details sheet
    func mapDidRequestVehicleDetails(session: Session, vehicle: Vehicle) {

        let vc = factory.makeVehicleDetailsScreen(
            session: session,
            vehicle: vehicle
        )

        configureSheetPresentation(for: vc)

        navigationController.present(vc, animated: true)
    }
}

// MARK: - Sheet Presentation Configuration

private extension MapCoordinator {

    /// Common sheet configuration used for bottom sheet presentations
    func configureSheetPresentation(for vc: UIViewController) {

        guard let sheet = vc.sheetPresentationController else { return }

        sheet.detents = [
            .medium(),
            .large()
        ]

        sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        sheet.prefersEdgeAttachedInCompactHeight = true
        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true

        // iOS 26+ visual enhancement (if available)
        if #available(iOS 26.1, *) {
            sheet.applyGlassAppearance(cornerRadius: 32)
        }
    }
}
