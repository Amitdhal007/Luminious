import UIKit

struct DefaultHeadingProcessor: HeadingProcessing {
    
    private var corrector = OrientationCorrector()
    
    mutating func process(
        raw: CGFloat,
        orientation: UIDeviceOrientation
    ) -> CGFloat {
        let correction = corrector.correction(for: orientation)
        return -(raw + correction).degreesToRadians
    }
}
