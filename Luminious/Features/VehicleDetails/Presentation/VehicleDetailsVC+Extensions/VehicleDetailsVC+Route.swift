import MapKit
import SDWebImage
import UIKit

extension VehicleDetailsVC {
    
    internal func loadRoute() {
        
        routeLoadTask =
        Task { [weak self] in
            
            guard let self
            else {
                return
            }
            
            do {
                
                let route =
                try await viewModel
                    .fetchRoute()
                
                guard !Task.isCancelled
                else {
                    return
                }
                
                await MainActor.run { [weak self] in
                    
                    guard let self
                    else {
                        return
                    }
                    
                    bind()
                    
                    updateTripStatus()
                    
                    drawRoute(
                        route
                    )
                    
                    addMarkers(
                        route
                    )
                }
                
            } catch {
                
                guard !Task.isCancelled
                else {
                    return
                }
                
                await MainActor.run { [weak self] in
                    
                    guard let self
                    else {
                        return
                    }
                    
                    toast.show(
                        style:
                                .error,
                        
                        title:
                            "Route Error",
                        
                        subtitle:
                            error.localizedDescription
                    )
                }
            }
        }
    }
    
    internal func drawRoute(
        _ coordinates:
        [CLLocationCoordinate2D]
    ) {
        
        guard
            !coordinates.isEmpty
        else {
            return
        }
        
        animatedCoordinates = []
        
        let full =
        MKPolyline(
            coordinates:
                coordinates,
            count:
                coordinates.count
        )
        
        fullRouteOverlay =
        full
        
        playbackMapView
            .addOverlay(
                full
            )
        
        playbackMapView
            .setVisibleMapRect(
                full.boundingMapRect,
                edgePadding:
                    UIEdgeInsets(
                        top: 60,
                        left: 60,
                        bottom: 60,
                        right: 60
                    ),
                animated: true
            )
    }
}
