import CoreLocation

extension CLLocationCoordinate2D {

    func randomCoordinate(
        withinKilometers radius: Double
    ) -> CLLocationCoordinate2D {

        let radiusMeters =
            radius * 1000

        let distance =
            Double.random(
                in: 500...radiusMeters
            )

        let bearing =
            Double.random(
                in: 0...(2 * .pi)
            )

        let earthRadius =
            6_371_000.0

        let lat1 =
            latitude * .pi / 180

        let lon1 =
            longitude * .pi / 180

        let lat2 =
            asin(
                sin(lat1) * cos(distance / earthRadius)
                +
                cos(lat1)
                *
                sin(distance / earthRadius)
                *
                cos(bearing)
            )

        let lon2 =
            lon1 +
            atan2(
                sin(bearing)
                *
                sin(distance / earthRadius)
                *
                cos(lat1),

                cos(distance / earthRadius)
                -
                sin(lat1)
                *
                sin(lat2)
            )

        return CLLocationCoordinate2D(
            latitude:
                lat2 * 180 / .pi,
            longitude:
                lon2 * 180 / .pi
        )
    }
    
    func heading(
            to destination:
                CLLocationCoordinate2D
        ) -> CLLocationDirection {

            let lat1 =
                latitude * .pi / 180

            let lon1 =
                longitude * .pi / 180

            let lat2 =
                destination.latitude * .pi / 180

            let lon2 =
                destination.longitude * .pi / 180

            let dLon =
                lon2 - lon1

            let y =
                sin(dLon) * cos(lat2)

            let x =
                cos(lat1) * sin(lat2)
                -
                sin(lat1)
                *
                cos(lat2)
                *
                cos(dLon)

            let bearing =
                atan2(y, x)

            var degrees =
                bearing * 180 / .pi

            if degrees < 0 {
                degrees += 360
            }

            return degrees
        }
}
