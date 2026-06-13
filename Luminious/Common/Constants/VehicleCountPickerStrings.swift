import Foundation

enum VehicleCountPickerStrings {

    static let title =
        "Vehicle Configuration"

    static let message =
        "Select vehicle count"

    static let cancel =
        "Cancel"

    static func vehicleTitle(
        count: Int
    ) -> String {

        "\(count) Vehicles"
    }
}
