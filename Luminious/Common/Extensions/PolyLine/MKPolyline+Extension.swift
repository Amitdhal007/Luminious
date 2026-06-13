import MapKit

extension MKPolyline {

    func routePoints() -> [RoutePoint] {

        var coordinates = [CLLocationCoordinate2D](
            repeating: .init(),
            count: pointCount
        )

        getCoordinates(
            &coordinates,
            range: NSRange(
                location: 0,
                length: pointCount
            )
        )

        return coordinates
            .enumerated()
            .map { index, coordinate in

                let heading =
                    Self.heading(
                        currentIndex: index,
                        coordinates: coordinates
                    )

                return RoutePoint(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude,
                    heading: heading,
                    sequence: index
                )
            }
    }
}

private extension MKPolyline {

    static func heading(
        currentIndex: Int,
        coordinates: [CLLocationCoordinate2D]
    ) -> Double {

        guard currentIndex <
                coordinates.count - 1
        else {
            return 0
        }

        let start =
            coordinates[currentIndex]

        let end =
            coordinates[currentIndex + 1]

        let lat1 =
            start.latitude * .pi / 180

        let lon1 =
            start.longitude * .pi / 180

        let lat2 =
            end.latitude * .pi / 180

        let lon2 =
            end.longitude * .pi / 180

        let y =
            sin(lon2 - lon1)
            *
            cos(lat2)

        let x =
            cos(lat1)
            *
            sin(lat2)
            -
            sin(lat1)
            *
            cos(lat2)
            *
            cos(lon2 - lon1)

        return atan2(
            y,
            x
        ) * 180 / .pi
    }
}
