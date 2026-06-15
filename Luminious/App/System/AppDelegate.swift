import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Dependencies

    /// Central dependency container for the app.
    /// Provides access to shared services like CoreData and LocationManager.
    private let container = AppContainer.makeDefault()

    // MARK: - Application Lifecycle

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
            [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        configureLocationServices()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        persistApplicationState()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        persistApplicationState()
    }
}

// MARK: - Configuration

private extension AppDelegate {

    /// Requests location permissions and triggers initial location fetch.
    ///
    /// Assumption:
    /// - The app only needs "when in use" location permission at launch.
    /// - LocationManager is already properly configured in AppContainer.
    func configureLocationServices() {
        container.locationManager.requestWhenInUseAuthorization()
        container.locationManager.requestLocation()
    }
}

// MARK: - Persistence

private extension AppDelegate {

    /// Saves Core Data context safely.
    /// Called when app enters background or is about to terminate.
    ///
    /// Assumption:
    /// - CoreData stack is thread-safe for direct save calls here.
    func persistApplicationState() {
        try? container.coreDataStack.saveContext()
    }
}

// MARK: - Dependency Access

extension AppDelegate {

    /// Exposes dependency container for other modules (coordinators/view models).
    var appContainer: AppContainer {
        container
    }
}
