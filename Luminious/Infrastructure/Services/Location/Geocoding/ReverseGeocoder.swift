import CoreLocation
@preconcurrency import MapKit

@MainActor
final class ReverseGeocoder: ReverseGeocodingService {

    func fetchMapItem(
        for location: CLLocation
    ) async throws -> MKMapItem? {

        let request = MKReverseGeocodingRequest(
            location: location
        )

        let response = try await request?.mapItems

        return response?.first
    }
}
