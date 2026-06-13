import UIKit

struct OrientationCorrector {
    
    private var lastCorrection: CGFloat = 0
    
    mutating func correction(for orientation: UIDeviceOrientation) -> CGFloat {
        switch orientation {
        case .portrait:
            lastCorrection = 0
        case .portraitUpsideDown:
            lastCorrection = 180
        case .landscapeLeft:
            lastCorrection = 90
        case .landscapeRight:
            lastCorrection = 270
        case .faceUp:
            return lastCorrection
        case .faceDown:
            return -lastCorrection
        default:
            lastCorrection = 0
        }
        return lastCorrection
    }
}
