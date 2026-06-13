import UIKit

public struct CompassHeading {
    public let raw: CGFloat
    public let corrected: CGFloat
    public let orientation: UIDeviceOrientation

    public init(
        raw: CGFloat,
        corrected: CGFloat,
        orientation: UIDeviceOrientation
    ) {
        self.raw = raw
        self.corrected = corrected
        self.orientation = orientation
    }
}
