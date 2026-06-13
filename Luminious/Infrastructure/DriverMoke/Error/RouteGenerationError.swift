import Foundation

enum RouteGenerationError: LocalizedError {

    case routeNotFound

    var errorDescription: String? {

        switch self {

        case .routeNotFound:
            return "Unable to generate route."
        }
    }
}
