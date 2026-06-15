import CoreLocation
@preconcurrency import MapKit

@MainActor
protocol GeocodingServiceing {

    func reverseGeocodeShortAddress(
        _ location: CLLocation
    ) async throws -> String?

    func reverseGeocodeFullAddress(
        _ location: CLLocation
    ) async throws -> String?

    func reverseGeocodeAddress(
        _ location: CLLocation
    ) async throws -> Address?
}
