import CoreLocation

protocol SessionBootstrapService {

    func bootstrap(
        session: Session,
        userLocation: CLLocationCoordinate2D
    ) async throws
}
