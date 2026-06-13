import UIKit

final class MapCoordinator:
    Coordinating
{

    private let factory: MapFactory
    private let navigationController: UINavigationController
    private let onFinishSession: () -> Void

    init(
        factory: MapFactory,
        navigationController: UINavigationController,
        onFinishSession: @escaping () -> Void
    ) {

        self.factory = factory

        self.navigationController =
            navigationController

        self.onFinishSession =
            onFinishSession
    }

    func start() {

        let vc =
            factory.makeMapScreen(
                coordinator: self
            )

        navigationController
            .setViewControllers(
                [vc],
                animated: false
            )
    }
}
extension MapCoordinator: MapCoordinating {

    func mapDidRequestVehicleSearch(vehicles: [Vehicle]) {

        let searchVC = factory.makeSearchVehicleScreen(
            vehicles: vehicles
        )

        if let sheet = searchVC.sheetPresentationController {

            sheet.detents = [
                .medium(),
                .large(),
            ]

            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24

            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }

        navigationController.present(
            searchVC,
            animated: true
        )
    }

    func mapDidRequestAR() {
        print("AR requested from map")
    }

    func mapDidFinishSession() {
        onFinishSession()
    }
}
