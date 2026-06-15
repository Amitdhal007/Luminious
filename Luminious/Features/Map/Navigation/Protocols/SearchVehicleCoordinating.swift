import Foundation

/// Coordinator responsible for handling navigation events
/// from the Search Vehicle module.
protocol SearchVehicleCoordinating: AnyObject {

    /// Called when user closes/dismisses search screen
    func searchVehicleDidDismiss()

    /// Called when user selects a vehicle from the list
    func searchVehicleDidSelect(_ vehicle: Vehicle)
}
