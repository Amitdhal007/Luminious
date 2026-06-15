import CoreLocation
import Foundation

extension VehicleDetailsViewModel {

    var routeProgressText: String {

        guard let route
        else {
            return "-"
        }

        let totalPoints =
            route.routePoints.count

        guard totalPoints > 0
        else {
            return "-"
        }

        return
            "\(vehicle.currentRouteIndex + 1)/\(totalPoints)"
    }

    var routeCompletionPercentage: Double {

        guard let route
        else {
            return 0
        }

        let totalPoints =
            route.routePoints.count

        guard totalPoints > 1
        else {
            return 0
        }

        return min(
            Double(vehicle.currentRouteIndex)
                / Double(totalPoints - 1),
            1.0
        )
    }

    var routeCompletionText: String {

        "\(Int(routeCompletionPercentage * 100))%"
    }
}
