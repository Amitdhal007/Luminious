import UIKit

final class AppCoordinator: Coordinating {

    // MARK: - Core

    private let window: UIWindow

    private let container: AppContainer

    // MARK: - Presentation

    private let toast: ToastPresenting

    private let loader: LoaderPresenting

    // MARK: - Factories

    private let splashFactory: SplashFactory

   // private let mapFactory: MapFactory

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

        // MARK: - Factories

        self.splashFactory = DefaultSplashFactory(
            sessionRepository: container.sessionRepository,
            toast: toast
        )

//        self.mapFactory = DefaultMapFactory(
//            sessionRepository: container.sessionRepository,
//            vehicleRepository: container.vehicleRepository,
//            locationManager: container.locationManager,
//            toast: toast
//        )
    }

    // MARK: - Start

    func start() {

        showSplashFlow()
    }
}

private extension AppCoordinator {

    func showSplashFlow() {

        let nav = UINavigationController()

        nav.isNavigationBarHidden = true

        let splashFactory = DefaultSplashFactory(
            sessionRepository: container.sessionRepository,
            toast: toast
        )

        let coordinator = SplashCoordinator(
            factory: splashFactory,
            navigationController: nav,
            onResumeSession: { [weak self] in
                guard let self else { return }
                
                showMapFlow()
            },
            onNewSession: { [weak self] _ in
                guard let self else { return }
                
                showMapFlow()
            }
        )

        childCoordinator = coordinator

        coordinator.start()

        setRoot(nav)
    }
}

private extension AppCoordinator {

    func showMapFlow() {

//        let nav =
//            UINavigationController()
//
//        nav.isNavigationBarHidden =
//            true
//
//        let coordinator =
//            MapCoordinator(
//                factory: container.mapFactory,
//                navigationController: nav,
//                toast: toast,
//                loader: loader
//            )
//
//        childCoordinator =
//            coordinator
//
//        coordinator.start()
//
//        setRoot(nav)
    }
}

private extension AppCoordinator {

    func setRoot(
        _ rootController: UIViewController
    ) {

        window.rootViewController =
            rootController

        window.makeKeyAndVisible()

        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }
}
