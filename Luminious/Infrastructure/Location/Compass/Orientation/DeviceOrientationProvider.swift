import UIKit

final class DeviceOrientationProvider: OrientationProviding {
    
    var current: UIDeviceOrientation {
        UIDevice.current.orientation
    }
}
