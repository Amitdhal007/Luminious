import UIKit
import Combine
import MapKit

extension MapVC {
    
    public func configureBindings() {
        
        bindVehicles()
        bindEvents()
    }
}

private extension MapVC {
    
    private func bindVehicles() {
        
        viewModel
            .vehiclesPublisher
            .drop(while: { $0.isEmpty })
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] vehicles in
                
                guard let self
                else {
                    return
                }
                
                viewModel.setVehicles(vehicles)
                
                animateVehicleUpdates(
                    vehicles
                )
            }
            .store(
                in: &cancellables
            )
    }
    
    private func bindEvents() {
        
        viewModel
            .eventBus
            .events
            .receive(
                on: DispatchQueue.main
            )
            .sink { [weak self] event in
                
                self?
                    .handleEvent(
                        event
                    )
            }
            .store(
                in: &cancellables
            )
    }
    
    private func handleEvent(
        _ event: AppEvent
    ) {

        guard case .vehicleSelected(let vehicle) = event
        else {
            return
        }

        guard let annotation =
                viewModel.annotationMap[vehicle.id]
        else {
            return
        }

        mapView.selectAnnotation(
            annotation,
            animated: true
        )

        let region =
            MKCoordinateRegion(
                center: annotation.coordinate,
                latitudinalMeters: 500,
                longitudinalMeters: 500
            )

        mapView.setRegion(
            region,
            animated: true
        )
    }
}
