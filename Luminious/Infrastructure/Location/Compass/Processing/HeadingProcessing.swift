import UIKit

public protocol HeadingProcessing {
    mutating func process(
        raw: CGFloat,
        orientation: UIDeviceOrientation
    ) -> CGFloat
}
