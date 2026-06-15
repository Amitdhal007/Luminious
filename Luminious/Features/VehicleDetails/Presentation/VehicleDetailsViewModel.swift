import CoreLocation
import Foundation

final class VehicleDetailsViewModel {

    // Dependencies

    let vehicle: Vehicle
    let session: Session

    internal let routeRepository: RouteRepository
    internal let vehicleRepository: VehicleRepository

    // State

    internal var route: Route?

    internal var playbackState:
        PlaybackState = .idle

    internal var playbackTask:
        Task<Void, Never>?

    // Callbacks

    var onPlaybackMove:
        ((CLLocationCoordinate2D) -> Void)?

    var onPlaybackEnd:
        (() -> Void)?

    // Init

    init(
        vehicle: Vehicle,
        session: Session,
        routeRepository: RouteRepository,
        vehicleRepository: VehicleRepository
    ) {
        self.vehicle = vehicle
        self.session = session
        self.routeRepository = routeRepository
        self.vehicleRepository = vehicleRepository
    }
}
