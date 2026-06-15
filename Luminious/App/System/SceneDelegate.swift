import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - UI

    /// Main application window used to render UI hierarchy.
    var window: UIWindow?

    // MARK: - Core Components

    /// Root coordinator responsible for navigation flow.
    private var appCoordinator: AppCoordinator?

    /// Shared dependency container from AppDelegate.
    private var container: AppContainer?

    // MARK: - Scene Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else {
            fatalError("Scene is not UIWindowScene")
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate not accessible")
        }

        // MARK: - Dependency Resolution
        // Assumption: AppContainer is created once in AppDelegate and shared globally
        container = appDelegate.appContainer

        // MARK: - Window Setup
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // MARK: - Coordinator Bootstrap
        // Responsibility: AppCoordinator owns entire navigation flow
        appCoordinator = AppCoordinator(
            container: container!,
            toast: ToastPresenter(window: window),
            loader: LoaderPresenter(window: window),
            window: window
        )

        appCoordinator?.start()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        persistCoreData()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        persistCoreData()
    }
}

// MARK: - Persistence Layer

private extension SceneDelegate {

    /// Persists Core Data context when app transitions to background or disconnects.
    ///
    /// Assumptions:
    /// - CoreDataStack is thread-safe for direct save calls.
    /// - Save failure should not crash app; only logged in DEBUG builds.
    func persistCoreData() {

        guard let container else { return }

        do {
            try container.coreDataStack.saveContext()

            #if DEBUG
            print("✅ Core Data saved successfully")
            #endif

        } catch {

            #if DEBUG
            print("""
            ❌ Core Data save failed
            Error: \(error)
            Description: \(error.localizedDescription)
            """)
            #endif
        }
    }
}
