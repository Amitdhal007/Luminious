import MapKit

enum DirectionMapper {
    
    static func compassDirection(
        from heading: Double
    ) -> String {

        let directions = [
            "N",
            "NE",
            "E",
            "SE",
            "S",
            "SW",
            "W",
            "NW"
        ]

        let index =
            Int(
                round(
                    heading / 45
                )
            ) % directions.count

        return directions[index]
    }
}
