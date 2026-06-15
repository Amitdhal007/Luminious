import Foundation

extension VehicleDetailsViewModel {
    
    var isCreated: Bool {
        route?.status == .created
    }
    
    var isRunning: Bool {
        route?.status == .running
    }
    
    var isCompleted: Bool {
        route?.status == .completed
    }
    
    var showPlayback: Bool {
        
        route?.status == .completed
    }
}

extension VehicleDetailsViewModel {
    
    enum PlaybackState {
        
        case idle
        
        case playing(
            index: Int
        )
        
        case paused(
            index: Int
        )
        
        case completed
    }
}
