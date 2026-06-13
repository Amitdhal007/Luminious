import UIKit

public struct ToastViewConfiguration {

    public let minHeight: CGFloat
    public let minWidth: CGFloat

    public let cornerRadius: CGFloat?

    public init(
        minHeight: CGFloat = 58,
        minWidth: CGFloat = 150,
        cornerRadius: CGFloat? = nil
    ) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.cornerRadius = cornerRadius
    }
}
