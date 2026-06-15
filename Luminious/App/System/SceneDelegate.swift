import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    private var appCoordinator: AppCoordinator!

    private var container: AppContainer!

    // MARK: - Scene Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {

        guard let windowScene = scene as? UIWindowScene else {
            fatalError(
                "Failed to cast UIScene to UIWindowScene"
            )
        }

        guard
            let appDelegate =
                UIApplication.shared.delegate as? AppDelegate
        else {
            fatalError(
                "Failed to retrieve AppDelegate"
            )
        }

        // MARK: - Dependencies

        container = appDelegate.appContainer

        // MARK: - Window

        let window = UIWindow(
            windowScene: windowScene
        )

        self.window = window

        // MARK: - Coordinator

        appCoordinator = AppCoordinator(
            container: container,
            toast: ToastPresenter(
                window: window
            ),
            loader: LoaderPresenter(
                window: window
            ),
            window: window
        )

        appCoordinator.start()
    }

    func sceneDidBecomeActive(
        _ scene: UIScene
    ) {

    }

    func sceneWillResignActive(
        _ scene: UIScene
    ) {

    }

    func sceneWillEnterForeground(
        _ scene: UIScene
    ) {

    }

    func sceneDidEnterBackground(
        _ scene: UIScene
    ) {

        saveContext()
    }

    func sceneDidDisconnect(
        _ scene: UIScene
    ) {

        saveContext()
    }
}

extension SceneDelegate {

    private func saveContext() {

        do {

            try container
                .coreDataStack
                .saveContext()

            #if DEBUG
                print(
                    """
                    Core Data save successful
                    """
                )
            #endif

        } catch {

            #if DEBUG
                print(
                    """
                    Failed to save Core Data

                    Error:
                    \(error)

                    Description:
                    \(error.localizedDescription)
                    """
                )
            #endif
        }
    }
}
