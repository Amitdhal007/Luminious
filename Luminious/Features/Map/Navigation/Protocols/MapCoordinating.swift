import Foundation

/// Coordinator contract for Map flow navigation.
///
/// Responsible for handling all navigation events triggered from Map module.
/// Keeps ViewControllers free from navigation logic.
protocol MapCoordinating: AnyObject {

    // MARK: - Navigation Actions

    /// Navigates to AR experience from map context
    func mapDidRequestAR()

    /// Presents vehicle search screen with available vehicles
    func mapDidRequestVehicleSearch(vehicles: [Vehicle])

    /// Presents vehicle details for selected vehicle in session context
    func mapDidRequestVehicleDetails(
        session: Session,
        vehicle: Vehicle
    )

    /// Ends current session and exits Map flow
    func mapDidFinishSession()
}
