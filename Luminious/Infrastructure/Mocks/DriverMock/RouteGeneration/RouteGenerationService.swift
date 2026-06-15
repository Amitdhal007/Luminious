import CoreLocation

protocol RouteGenerationService {

    func generateRoute(
        near coordinate: CLLocationCoordinate2D
    ) async throws -> Route
}
