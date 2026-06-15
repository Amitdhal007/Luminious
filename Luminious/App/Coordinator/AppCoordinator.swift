import UIKit

final class AppCoordinator: Coordinating {

    // MARK: - Core

    private let window: UIWindow
    private let container: AppContainer

    // MARK: - Presentation

    private let toast: ToastPresenting
    private let loader: LoaderPresenting

    // MARK: - State

    private var childCoordinator: Coordinating?

    // MARK: - Init

    init(
        container: AppContainer,
        toast: ToastPresenting,
        loader: LoaderPresenting,
        window: UIWindow
    ) {
        self.container = container
        self.toast = toast
        self.loader = loader
        self.window = window
    }

    // MARK: - Start

    func start() {
        showSplashFlow()
    }
}
extension AppCoordinator {

    private func showSplashFlow() {

        let nav = UINavigationController()
        nav.isNavigationBarHidden = true

        let splashFactory = DefaultSplashFactory(
            sessionRepository: container.sessionRepository,
            sessionBootstrapService: container.sessionBootstrapService,
            locationProvider: container.locationManager,
            toast: toast
        )

        let coordinator = SplashCoordinator(
            factory: splashFactory,
            navigationController: nav,
            onResumeSession: { [weak self] in
                guard let self else { return }
                self.showMapFlow()
            },
            onNewSession: { [weak self] _ in
                guard let self else { return }
                self.showMapFlow()
            }
        )

        childCoordinator = coordinator
        coordinator.start()

        setRoot(nav)
    }
}
extension AppCoordinator {

    private func showMapFlow() {

        let nav = UINavigationController()
        nav.isNavigationBarHidden = true

        let mapFactory = DefaultMapFactory(
            sessionRepository: container.sessionRepository,
            vehicleRepository: container.vehicleRepository,
            routeRepository: container.routeRepository,
            locationManager: container.locationManager,
            eventBus: container.eventBus,
            toast: toast,
            loader: loader,
            vehicleSimulationService: container.vehicleSimulationService,
            sessionBootstrapService: container.sessionBootstrapService
        )

        let coordinator = MapCoordinator(
            factory: mapFactory,
            navigationController: nav,
            onFinishSession: { [weak self] in
                guard let self else { return }
                self.showSplashFlow()
            }
        )

        childCoordinator = coordinator
        coordinator.start()

        setRoot(nav)
    }
}
extension AppCoordinator {

    private func setRoot(_ rootController: UIViewController) {

        window.rootViewController = rootController
        window.makeKeyAndVisible()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
