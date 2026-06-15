import Foundation

protocol MapCoordinating:
    AnyObject
{
    func mapDidRequestAR()

    func mapDidRequestVehicleSearch(
        vehicles: [Vehicle]
    )

    func mapDidRequestVehicleDetails(
        session: Session,
        vehicle: Vehicle
    )

    func mapDidFinishSession()
}
