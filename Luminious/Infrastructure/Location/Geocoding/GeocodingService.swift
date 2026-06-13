import CoreLocation
@preconcurrency import MapKit

@MainActor
final class GeocodingService: GeocodingServiceing {

    // MARK: - Dependencies

    private let geocoder: ReverseGeocodingService

    // MARK: - Helpers

    private let mapper = AddressMapper()
    private let formatter = AddressFormatter()

    // MARK: - Init

    init(
        geocoder: ReverseGeocodingService
    ) {
        self.geocoder = geocoder
    }

    // MARK: - Public

    func reverseGeocodeShortAddress(
        _ location: CLLocation
    ) async throws -> String? {

        guard let mapItem = try await geocoder.fetchMapItem(
            for: location
        ) else {
            return nil
        }

        return formatter.shortAddress(
            from: mapItem
        )
    }

    func reverseGeocodeFullAddress(
        _ location: CLLocation
    ) async throws -> String? {

        guard let mapItem = try await geocoder.fetchMapItem(
            for: location
        ) else {
            return nil
        }

        return formatter.fullAddress(
            from: mapItem
        )
    }

    func reverseGeocodeAddress(
        _ location: CLLocation
    ) async throws -> Address? {

        guard let mapItem = try await geocoder.fetchMapItem(
            for: location
        ) else {
            return nil
        }

        return mapper.map(mapItem)
    }
}
