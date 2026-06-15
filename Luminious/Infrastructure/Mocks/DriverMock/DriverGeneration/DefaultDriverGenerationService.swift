import Foundation

final class DefaultDriverGenerationService:
    DriverGenerationService
{

    func generateVehicles(
        count: Int
    ) -> [Vehicle] {

        DriverSeedData.drivers
            .prefix(count)
            .map { driver in

                Vehicle(
                    id: UUID(),

                    driverName:
                        driver.name,

                    driverAvatarURL:
                        .init(
                            string:
                                driver.avatarURL
                        ),

                    vehicleNumber:
                        Self.randomVehicleNumber(),

                    vehicleType:
                        VehicleType
                            .allCases
                            .randomElement()!,

                    rating:
                        Double.random(
                            in: 4.0...5.0
                        ),

                    currentLatitude: 0,
                    currentLongitude: 0,
                    currentHeading: 0,
                    currentRouteIndex: 0,

                    isActive: true,

                    updatedAt: .now
                )
            }
    }
}

extension DefaultDriverGenerationService {

    private static func randomVehicleNumber() -> String {

        let states = [
            "DL",
            "MH",
            "KA",
            "WB",
            "TN",
            "UP",
            "RJ",
            "HR",
            "PB",
            "GJ",
        ]

        let letters =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

        let state =
            states.randomElement()!

        let district =
            Int.random(
                in: 10...99
            )

        let series =
            String(
                (0..<2).map { _ in
                    letters.randomElement()!
                }
            )

        let number =
            Int.random(
                in: 1000...9999
            )

        return
            "\(state)\(district)\(series)\(number)"
    }
}
