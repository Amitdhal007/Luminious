import Foundation

protocol DriverGenerationService {

    func generateVehicles(
        count: Int
    ) -> [Vehicle]
}
