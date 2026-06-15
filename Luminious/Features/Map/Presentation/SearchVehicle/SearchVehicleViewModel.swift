import Foundation
import Combine

final class SearchVehicleViewModel {

    // MARK: - Published

    @Published
    private(set) var vehicles:
        [Vehicle]

    // MARK: - Dependencies

    let eventBus:
        AppEventDispatching

    // MARK: - Storage

    private let allVehicles:
        [Vehicle]

    // MARK: - Init

    init(
        vehicles: [Vehicle],
        eventBus: AppEventDispatching
    ) {

        self.allVehicles =
            vehicles

        self.vehicles =
            vehicles

        self.eventBus =
            eventBus
    }
}
extension SearchVehicleViewModel {

    func search(
        query: String
    ) {

        let searchText =
            query
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .lowercased()

        guard !searchText.isEmpty else {

            vehicles =
                allVehicles

            return
        }

        vehicles =
            allVehicles.filter {

                $0.driverName
                    .lowercased()
                    .contains(searchText)

                ||

                $0.vehicleNumber
                    .lowercased()
                    .contains(searchText)
            }
    }
}
extension SearchVehicleViewModel {

    func selectVehicle(
        _ vehicle: Vehicle
    ) {

        eventBus.emit(
            .vehicleSelected(
                vehicle
            )
        )
    }
}
