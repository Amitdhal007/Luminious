import Foundation

protocol SearchVehicleCoordinating:
    AnyObject
{
    func searchVehicleDidDismiss()

    func searchVehicleDidSelect(
        _ vehicle: Vehicle
    )
}
