import IQKeyboardManagerSwift
import IQKeyboardToolbarManager
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

        configureKeyboard()

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

    func configureKeyboard() {

        IQKeyboardManager.shared.isEnabled = true

        IQKeyboardToolbarManager.shared.isEnabled = false

        IQKeyboardManager.shared.resignOnTouchOutside = true
    }
}

// MARK: - Dependency Access

extension AppDelegate {

    var appContainer: AppContainer {
        container
    }
}
