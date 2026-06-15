import CoreLocation
@preconcurrency import MapKit

@MainActor
protocol ReverseGeocodingService {

    func fetchMapItem(
        for location: CLLocation
    ) async throws -> MKMapItem?
}
