import Foundation

/// Global application-level events used for decoupled communication
/// between modules via AppEventBus.
///
/// Design intent:
/// - Represents meaningful domain/UI actions
/// - Avoids stateful or placeholder cases
/// - Keeps events strongly typed
enum AppEvent: Sendable {

    /// User selected a vehicle in the UI
    case vehicleSelected(Vehicle)
}
