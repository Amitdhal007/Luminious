import UIKit

/// Root coordinator responsible for controlling the entire application flow.
///
/// Responsibilities:
/// - Manages high-level navigation flows (Splash → Map → Restart flow)
/// - Owns child coordinators lifecycle
/// - Switches root view controller when flow changes
///
/// Assumptions:
/// - Only one active flow exists at a time
/// - AppContainer provides all shared dependencies
final class AppCoordinator: Coordinating {

    // MARK: - Core

    private let window: UIWindow
    private let container: AppContainer

    // MARK: - UI Services

    private let toast: ToastPresenting
    private let loader: LoaderPresenting

    // MARK: - State

    /// Currently active child flow coordinator.
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

private extension AppCoordinator {

    /// Replaces current flow and sets a new root navigation controller.
    func transition(to coordinator: Coordinating, root: UINavigationController) {

        childCoordinator = coordinator
        coordinator.start()
        setRoot(root)
    }
}

private extension AppCoordinator {

    func showSplashFlow() {

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
                self?.showMapFlow()
            },
            onNewSession: { [weak self] _ in
                self?.showMapFlow()
            }
        )

        transition(to: coordinator, root: nav)
    }
}

private extension AppCoordinator {

    func showMapFlow() {

        let nav = UINavigationController()
        nav.isNavigationBarHidden = true
        
        let dependencies = MapDependencies(
            sessionRepository: container.sessionRepository,
            vehicleRepository: container.vehicleRepository,
            routeRepository: container.routeRepository,
            locationManager: container.locationManager,
            vehicleSimulationService: container.vehicleSimulationService,
            sessionBootstrapService: container.sessionBootstrapService,
            eventBus: container.eventBus,
            toast: toast,
            loader: loader
        )

        let mapFactory = DefaultMapFactory(
            dependencies: dependencies
        )

        let coordinator = MapCoordinator(
            factory: mapFactory,
            navigationController: nav,
            onFinishSession: { [weak self] in
                self?.showSplashFlow()
            }
        )

        transition(to: coordinator, root: nav)
    }
}

private extension AppCoordinator {

    func setRoot(_ rootController: UIViewController) {

        window.rootViewController = rootController
        window.makeKeyAndVisible()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { }
        )
    }
}
