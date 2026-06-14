import Combine
import Foundation

final class DefaultVehicleSimulationService:
    VehicleSimulationService {

    // MARK: - Constants

    private enum Constants {

        static let tickInterval: TimeInterval = 5.0

        static let maximumTotalTicks: Int = 60
    }

    // MARK: - Dependencies

    private let vehicleRepository:
        VehicleRepository

    private let routeRepository:
        RouteRepository

    // MARK: - State

    private var timer: Timer?

    private var sessionId: UUID?

    private var routeCache: [UUID: Route] = [:]

    private var stepCache: [UUID: Int] = [:]

    private let vehiclesSubject =
        CurrentValueSubject<[Vehicle], Never>([])

    var vehiclesPublisher:
        AnyPublisher<[Vehicle], Never> {

        vehiclesSubject
            .eraseToAnyPublisher()
    }

    // MARK: - Init

    init(
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository
    ) {

        self.vehicleRepository =
            vehicleRepository

        self.routeRepository =
            routeRepository
    }

    // MARK: - Public

    func start(
        sessionId: UUID
    ) {

        stop()

        self.sessionId = sessionId
        routeCache = [:]
        stepCache = [:]

        timer = Timer.scheduledTimer(
            withTimeInterval:
                Constants.tickInterval,
            repeats: true
        ) { [weak self] _ in

            self?.tick()
        }

        // Immediate first tick
        tick()
    }

    func stop() {

        timer?.invalidate()
        timer = nil
    }
}

// MARK: - Tick Logic

private extension DefaultVehicleSimulationService {

    func tick() {

        guard let sessionId else {
            return
        }

        Task { [weak self] in

            guard let self else {
                return
            }

            do {

                let vehicles =
                    try await vehicleRepository
                        .fetchVehicles(
                            sessionId: sessionId
                        )

                let activeVehicles =
                    vehicles.filter {
                        $0.isActive
                    }

                for vehicle in activeVehicles {

                    await advanceVehicle(
                        vehicle
                    )
                }

                let updatedVehicles =
                    try await vehicleRepository
                        .fetchVehicles(
                            sessionId: sessionId
                        )

                await MainActor.run {

                    vehiclesSubject.send(
                        updatedVehicles
                    )
                }

            } catch {

                #if DEBUG
                print(
                    "Simulation tick error: \(error.localizedDescription)"
                )
                #endif
            }
        }
    }
}

// MARK: - Vehicle Advancement

private extension DefaultVehicleSimulationService {

    func advanceVehicle(
        _ vehicle: Vehicle
    ) async {

        do {

            let route =
                try await fetchRoute(
                    for: vehicle
                )

            guard let route else {
                return
            }

            let totalPoints =
                route.routePoints.count

            guard totalPoints > 1 else {
                return
            }

            let step =
                calculateStep(
                    vehicleId: vehicle.id,
                    totalPoints: totalPoints
                )

            let currentIndex =
                vehicle.currentRouteIndex

            let nextIndex =
                min(
                    currentIndex + step,
                    totalPoints - 1
                )

            guard nextIndex > currentIndex else {

                vehicle.isActive = false
                vehicle.updatedAt = .now

                try await vehicleRepository
                    .update(vehicle: vehicle)

                return
            }

            let targetPoint =
                route.routePoints[nextIndex]

            vehicle.currentLatitude =
                targetPoint.latitude

            vehicle.currentLongitude =
                targetPoint.longitude

            vehicle.currentHeading =
                targetPoint.heading

            vehicle.currentRouteIndex =
                nextIndex

            vehicle.updatedAt = .now

            // Mark inactive if we reached
            // the last point
            if nextIndex >= totalPoints - 1 {
                vehicle.isActive = false
            }

            try await vehicleRepository
                .update(vehicle: vehicle)

        } catch {

            #if DEBUG
            print(
                "Failed to advance vehicle \(vehicle.id): \(error.localizedDescription)"
            )
            #endif
        }
    }

    func fetchRoute(
        for vehicle: Vehicle
    ) async throws -> Route? {

        if let cached = routeCache[vehicle.id] {
            return cached
        }

        let route =
            try await routeRepository
                .fetchRoute(
                    vehicleId: vehicle.id
                )

        if let route {
            routeCache[vehicle.id] = route
        }

        return route
    }

    func calculateStep(
        vehicleId: UUID,
        totalPoints: Int
    ) -> Int {

        if let cached = stepCache[vehicleId] {
            return cached
        }

        // Small routes (< 60 pts): step = 1
        //   → finishes naturally in 1-5 min
        // Large routes (300 pts): step = 5
        //   → finishes in ~5 min
        let step = max(
            1,
            totalPoints
                / Constants.maximumTotalTicks
        )

        stepCache[vehicleId] = step

        return step
    }
}
