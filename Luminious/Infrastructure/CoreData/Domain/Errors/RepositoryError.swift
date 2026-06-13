import Foundation

enum RepositoryError: LocalizedError {

    case sessionNotFound
    case vehicleNotFound
    case routeNotFound

    var errorDescription: String? {

        switch self {

        case .sessionNotFound:
            return "Session not found"

        case .vehicleNotFound:
            return "Vehicle not found"

        case .routeNotFound:
            return "Route not found"
        }
    }
}
