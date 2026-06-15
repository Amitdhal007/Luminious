@preconcurrency import MapKit

struct AddressMapper {

    func map(
        _ mapItem: MKMapItem
    ) -> Address? {

        let representations = mapItem.addressRepresentations

        return Address(
            city: representations?.cityName ?? "",
            state: representations?.regionName ?? "",
            country: representations?.region?.identifier ?? "",
            postalCode: "",
            fullAddress:
                representations?.fullAddress(
                    includingRegion: true,
                    singleLine: true
                ) ?? ""
        )
    }
}
