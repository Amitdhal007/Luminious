import Foundation
@preconcurrency import MapKit

struct PlaceDisplayMapper {

    public func map(
        _ mapItem: MKMapItem
    ) -> PlaceDisplay {

        let title = buildTitle(from: mapItem)
        let subtitle = buildSubtitle(from: mapItem)

        return PlaceDisplay(
            title: title,
            subtitle: subtitle
        )
    }
}

// MARK: - Private

extension PlaceDisplayMapper {

    private func buildTitle(
        from mapItem: MKMapItem
    ) -> String {

        let address = mapItem.addressRepresentations

        if let name = mapItem.name,
            !name.isEmpty
        {
            return name
        }

        if let shortAddress = address?.cityWithContext(.short),
            !shortAddress.isEmpty
        {
            return shortAddress
        }

        if let city = address?.cityName,
            !city.isEmpty
        {
            return city
        }

        return "Unknown Location"
    }

    private func buildSubtitle(
        from mapItem: MKMapItem
    ) -> String {

        let address = mapItem.addressRepresentations

        let parts = [
            address?.regionName,
            address?.region?.identifier,
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }

        return parts.joined(separator: ", ")
    }
}
