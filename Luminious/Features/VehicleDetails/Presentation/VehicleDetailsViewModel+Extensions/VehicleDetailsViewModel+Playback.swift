import CoreLocation
import Foundation

extension VehicleDetailsViewModel {
    
    func startPlayback() async {
        
        guard showPlayback
        else {
            return
        }
        
        if case .playing =
            playbackState
        {
            return
        }
        
        if route == nil {
            
            try? await loadRoute()
        }
        
        let points =
        route?
            .routePoints
        ?? []
        
        let startIndex: Int
        
        switch playbackState {
            
        case .paused(
            let
            index
        ):
            startIndex =
            index
            
        default:
            startIndex =
            0
        }
        
        playbackTask?.cancel()
        
        playbackTask =
        Task {
            
            await play(
                points,
                from:
                    startIndex
            )
        }
    }
    
    func pausePlayback() {
        
        guard
            case .playing(
                let
                index
            ) = playbackState
        else {
            return
        }
        
        playbackState =
            .paused(
                index:
                    index
            )
        
        playbackTask?.cancel()
    }
    
    func stopPlayback() {
        
        playbackTask?.cancel()
        
        playbackState =
            .idle
        
        guard
            let first =
                route?
                .routePoints
                .first
        else {
            return
        }
        
        onPlaybackMove?(
            CLLocationCoordinate2D(
                latitude:
                    first.latitude,
                longitude:
                    first.longitude
            )
        )
    }
}
extension VehicleDetailsViewModel {
    
    private func play(
        _ points:
        [RoutePoint],
        
        from start:
        Int
    ) async {
        
        for index
                in start..<points.count
        {
            
            guard
                !Task.isCancelled
            else {
                return
            }
            
            playbackState =
                .playing(
                    index:
                        index
                )
            
            let point =
            points[index]
            
            await MainActor.run {
                
                onPlaybackMove?(
                    CLLocationCoordinate2D(
                        latitude:
                            point.latitude,
                        
                        longitude:
                            point.longitude
                    )
                )
            }
            
            try? await Task.sleep(
                for:
                        .milliseconds(
                            700
                        )
            )
        }
        
        playbackState =
            .completed
        
        onPlaybackEnd?()
    }
}
extension VehicleDetailsViewModel {
    
    var showPlay: Bool {
        
        switch playbackState {
            
        case .idle,
                .paused:
            
            return true
            
        case .playing,
                .completed:
            
            return false
        }
    }
    
    var showPause: Bool {
        
        if case .playing =
            playbackState
        {
            
            return true
        }
        
        return false
    }
    
    var showStop: Bool {
        
        switch playbackState {
            
        case .playing,
                .paused,
                .completed:
            
            return true
            
        case .idle:
            
            return false
        }
    }
}
