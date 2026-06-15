import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Dependencies

    private let container =
        AppContainer.makeDefault()

    // MARK: - Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        configureLocation()

        return true
    }

    func applicationDidEnterBackground(
        _ application: UIApplication
    ) {

        try? container
            .coreDataStack
            .saveContext()
    }

    func applicationWillTerminate(
        _ application: UIApplication
    ) {

        try? container
            .coreDataStack
            .saveContext()
    }
}

// MARK: - Configuration

private extension AppDelegate {

    func configureLocation() {

        container.locationManager
            .requestWhenInUseAuthorization()

        container.locationManager
            .requestLocation()
    }
}

// MARK: - Dependency Access

extension AppDelegate {

    var appContainer: AppContainer {
        container
    }
}
