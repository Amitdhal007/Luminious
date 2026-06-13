import UIKit

final class SplashCoordinator: Coordinating {

    private let factory: SplashFactory

    private let navigationController:
        UINavigationController

    private let onResumeSession:
        () -> Void

    private let onNewSession:
        (Session) -> Void

    init(
        factory: SplashFactory,
        navigationController: UINavigationController,
        onResumeSession: @escaping () -> Void,
        onNewSession: @escaping (Session) -> Void
    ) {

        self.factory = factory

        self.navigationController =
            navigationController

        self.onResumeSession =
            onResumeSession

        self.onNewSession =
            onNewSession
    }

    func start() {

        let vc =
            factory.makeSplashScreen(
                coordinator: self
            )

        navigationController
            .setViewControllers(
                [vc],
                animated: false
            )
    }
}
extension SplashCoordinator:
    SplashCoordinating {

    func splashDidRequestResumeSession() {

        onResumeSession()
    }

    func splashDidCreateNewSession(
        _ session: Session
    ) {

        onNewSession(session)
    }
}
