import Combine
import Foundation

final class DefaultVehicleSimulationService:
    VehicleSimulationService
{

    // MARK: - Constants

    private enum Constants {

        static let tickInterval:
            TimeInterval = 5.0
    }

    // MARK: - Dependencies

    private let sessionRepository:
        SessionRepository

    private let vehicleRepository:
        VehicleRepository

    private let routeRepository:
        RouteRepository

    // MARK: - State

    private var timer: Timer?

    private var sessionId: UUID?

    private var routeCache:
        [UUID: Route] = [:]

    private let vehiclesSubject =
        CurrentValueSubject<
            [Vehicle],
            Never
        >([])

    var vehiclesPublisher:
        AnyPublisher<[Vehicle], Never>
    {
        vehiclesSubject
            .eraseToAnyPublisher()
    }

    // MARK: - Init

    init(
        vehicleRepository: VehicleRepository,
        routeRepository: RouteRepository,
        sessionRepository: SessionRepository
    ) {

        self.vehicleRepository =
            vehicleRepository

        self.routeRepository =
            routeRepository

        self.sessionRepository =
            sessionRepository
    }

    // MARK: - Public

    func start(
        sessionId: UUID
    ) {

        stop()

        self.sessionId =
            sessionId

        routeCache = [:]

        Task {

            do {

                let vehicles =
                    try await vehicleRepository
                        .fetchVehicles(
                            sessionId: sessionId
                        )

                for vehicle in vehicles {

                    guard let route =
                        try await routeRepository
                            .fetchRoute(
                                vehicleId:
                                    vehicle.id
                            )
                    else {
                        continue
                    }

                    if route.startedAt == nil {

                        route.start()

                        try await routeRepository
                            .update(
                                route: route
                            )
                    }

                    routeCache[
                        vehicle.id
                    ] = route
                }

            } catch {

                #if DEBUG
                print(
                    "Route start failed"
                )
                #endif
            }
        }

        timer =
            Timer.scheduledTimer(
                withTimeInterval:
                    Constants.tickInterval,
                repeats: true
            ) { [weak self] _ in

                self?.tick()
            }

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

        guard let sessionId
        else {
            return
        }

        Task { [weak self] in

            guard let self
            else {
                return
            }

            do {

                let vehicles =
                    try await vehicleRepository
                        .fetchVehicles(
                            sessionId:
                                sessionId
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
                            sessionId:
                                sessionId
                        )

                let allCompleted =
                    !updatedVehicles
                        .isEmpty &&
                    updatedVehicles
                        .allSatisfy {
                            !$0.isActive
                        }

                if allCompleted {

                    await finishSession(
                        sessionId:
                            sessionId
                    )
                }

                await MainActor.run { [weak self] in
                    
                    guard let self
                    else {
                        return
                    }
 
                    vehiclesSubject.send(
                        updatedVehicles
                    )
                }

            } catch {

                #if DEBUG
                print(
                    "Simulation error: \(error)"
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

            guard let route =
                try await fetchRoute(
                    for: vehicle
                )
            else {
                return
            }

            let points =
                route.routePoints

            guard points.count > 1
            else {
                return
            }

            let currentIndex =
                vehicle.currentRouteIndex

            let nextIndex =
                min(
                    currentIndex + 1,
                    points.count - 1
                )

            guard nextIndex >
                currentIndex
            else {

                vehicle.isActive =
                    false

                vehicle.updatedAt =
                    .now

                try await vehicleRepository
                    .update(
                        vehicle:
                            vehicle
                    )

                await completeRoute(
                    for: vehicle
                )

                return
            }

            let point =
                points[nextIndex]

            vehicle.currentLatitude =
                point.latitude

            vehicle.currentLongitude =
                point.longitude

            vehicle.currentHeading =
                point.heading

            vehicle.currentRouteIndex =
                nextIndex

            vehicle.updatedAt =
                .now

            if nextIndex >=
                points.count - 1
            {

                vehicle.isActive =
                    false

                await completeRoute(
                    for: vehicle
                )
            }

            try await vehicleRepository
                .update(
                    vehicle:
                        vehicle
                )

        } catch {

            #if DEBUG
            print(
                "Advance failed"
            )
            #endif
        }
    }

    func fetchRoute(
        for vehicle: Vehicle
    ) async throws -> Route? {

        if let cached =
            routeCache[
                vehicle.id
            ] {
            return cached
        }

        let route =
            try await routeRepository
                .fetchRoute(
                    vehicleId:
                        vehicle.id
                )

        if let route {

            routeCache[
                vehicle.id
            ] = route
        }

        return route
    }

    func completeRoute(
        for vehicle: Vehicle
    ) async {

        do {

            guard let route =
                try await routeRepository
                    .fetchRoute(
                        vehicleId:
                            vehicle.id
                    )
            else {
                return
            }

            guard
                route.status
                    != .completed
            else {
                return
            }

            route.complete()

            try await routeRepository
                .update(
                    route:
                        route
                )

            routeCache[
                vehicle.id
            ] = route

        } catch {

            #if DEBUG
            print(
                "Complete route failed"
            )
            #endif
        }
    }

    func finishSession(
        sessionId: UUID
    ) async {

        do {

            guard let session =
                try await sessionRepository
                    .fetchLatest(),
                  session.id ==
                    sessionId
            else {
                return
            }

            session.endTrip()

            try await sessionRepository
                .update(
                    session:
                        session
                )

            stop()

        } catch {

            #if DEBUG
            print(
                "Finish session failed"
            )
            #endif
        }
    }
}
