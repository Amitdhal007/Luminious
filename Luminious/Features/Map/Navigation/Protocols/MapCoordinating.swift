import UIKit

protocol MapCoordinating:
    AnyObject
{
    func mapDidRequestAR()

    func mapDidRequestVehicleSearch(
        vehicles: [Vehicle]
    )

    func mapDidFinishSession()
}
