import Foundation

protocol MapFactory {

    func makeMapScreen(
        coordinator: MapCoordinating
    ) -> MapVC

    func makeSearchVehicleScreen(
        vehicles: [Vehicle]
    ) -> SearchVehicleVC
}
