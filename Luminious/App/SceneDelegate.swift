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
        
        
        Task {

            await runCoreDataSmokeTest(
                sessionRepository: container.sessionRepository,
                vehicleRepository: container.vehicleRepository,
                routeRepository: container.routeRepository
            )
        }
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

extension SceneDelegate {

    func runCoreDataSmokeTest(
        sessionRepository: SessionRepository,
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository
    ) async {

        print("🚀 Starting Core Data Smoke Test")

        do {

            // MARK: Session Create

            let session = Session(
                id: UUID(),
                name: "Test Session",
                status: 1,
                vehicleCount: 1,
                createdAt: .now,
                updatedAt: .now
            )

            try await sessionRepository.create(
                session: session
            )

            print("✅ Session Created")

            // MARK: Session Fetch

            guard let fetchedSession =
                try await sessionRepository
                    .fetchLatest()
            else {
                print("❌ Session Fetch Failed")
                return
            }

            print(
                """
                ✅ Session Fetched

                id:
                \(fetchedSession.id)
                """
            )

            // MARK: Session Update

            fetchedSession.status = 2

            try await sessionRepository.update(
                session: fetchedSession
            )

            print("✅ Session Updated")

            // MARK: Vehicle Create

            let vehicle = Vehicle(
                id: UUID(),
                driverName: "Test Driver",
                vehicleNumber: "PB10TEST",
                vehicleType: .crossover,
                rating: 4.8,
                currentLatitude: 30.0,
                currentLongitude: 75.0,
                currentHeading: 90,
                currentRouteIndex: 0,
                isActive: true,
                updatedAt: .now
            )

            try await vehicleRepository.create(
                vehicle: vehicle,
                sessionId: session.id
            )

            print("✅ Vehicle Created")

            // MARK: Vehicle Fetch

            let vehicles =
                try await vehicleRepository
                    .fetchVehicles(
                        sessionId: session.id
                    )

            guard let fetchedVehicle =
                vehicles.first
            else {
                print("❌ Vehicle Fetch Failed")
                return
            }

            print(
                """
                ✅ Vehicle Fetched

                id:
                \(fetchedVehicle.id)
                """
            )

            // MARK: Vehicle Update

            fetchedVehicle.currentLatitude =
                31.0

            try await vehicleRepository.update(
                vehicle: fetchedVehicle
            )

            print("✅ Vehicle Updated")

            // MARK: Route Create

            let route = Route(
                id: UUID(),
                routeName: "Test Route",
                totalDistance: 100,
                estimatedDuration: 120,
                createdAt: .now,
                routePoints: [
                    RoutePoint(
                        latitude: 30.0,
                        longitude: 75.0,
                        heading: 0,
                        sequence: 0
                    ),
                    RoutePoint(
                        latitude: 30.1,
                        longitude: 75.1,
                        heading: 45,
                        sequence: 1
                    )
                ]
            )

            try await routeRepository.create(
                route: route,
                vehicleId: vehicle.id
            )

            print("✅ Route Created")

            // MARK: Route Fetch

            guard let fetchedRoute =
                try await routeRepository
                    .fetchRoute(
                        vehicleId: vehicle.id
                    )
            else {
                print("❌ Route Fetch Failed")
                return
            }

            print(
                """
                ✅ Route Fetched

                points:
                \(fetchedRoute.routePoints.count)
                """
            )

            // MARK: Route Delete

            try await routeRepository.delete(
                routeId: route.id
            )

            print("✅ Route Deleted")

            // MARK: Vehicle Delete

            try await vehicleRepository.delete(
                vehicleId: vehicle.id
            )

            print("✅ Vehicle Deleted")

            // MARK: Session Delete

            try await sessionRepository.delete(
                sessionId: session.id
            )

            print("✅ Session Deleted")

            print(
                """
                🎉 ALL CORE DATA TESTS PASSED
                """
            )

        } catch {

            print(
                """
                ❌ CORE DATA TEST FAILED

                Error:
                \(error)
                """
            )
        }
    }
}
