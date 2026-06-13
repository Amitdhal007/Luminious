@preconcurrency import MapKit

struct AddressFormatter {

    func shortAddress(
        from mapItem: MKMapItem
    ) -> String {

        let representations = mapItem.addressRepresentations

        return representations?
            .fullAddress(
                includingRegion: false,
                singleLine: true
            )
        ?? mapItem.address?.shortAddress
        ?? ""
    }

    func fullAddress(
        from mapItem: MKMapItem
    ) -> String {

        let representations = mapItem.addressRepresentations

        return representations?
            .fullAddress(
                includingRegion: true,
                singleLine: true
            )
        ?? mapItem.address?.fullAddress
        ?? ""
    }
}
