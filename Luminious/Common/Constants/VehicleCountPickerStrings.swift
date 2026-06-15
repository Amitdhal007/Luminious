import Foundation

/// Localization namespace for Vehicle Count Picker screen.
///
/// Responsibility:
/// - Centralizes all user-facing strings for this screen
/// - Ensures consistency across UI components
/// - Prepares codebase for localization support
enum VehicleCountPickerStrings {

    // MARK: - Static Text

    static let title = NSLocalizedString(
        "vehicle_count_picker.title",
        value: "Vehicle Configuration",
        comment: "Title for vehicle count picker screen"
    )

    static let message = NSLocalizedString(
        "vehicle_count_picker.message",
        value: "Select vehicle count",
        comment: "Instruction text for selecting number of vehicles"
    )

    static let cancel = NSLocalizedString(
        "vehicle_count_picker.cancel",
        value: "Cancel",
        comment: "Cancel button title"
    )

    // MARK: - Dynamic Text

    /// Returns formatted vehicle count title.
    ///
    /// Example:
    /// - 1 → "1 Vehicle"
    /// - 3 → "3 Vehicles"
    static func vehicleTitle(count: Int) -> String {
        "\(count) \(count == 1 ? "Vehicle" : "Vehicles")"
    }
}
