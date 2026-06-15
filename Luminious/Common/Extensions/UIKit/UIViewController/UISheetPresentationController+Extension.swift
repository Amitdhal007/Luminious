import UIKit

@available(iOS 26.0, *)
extension UISheetPresentationController {

    func applyGlassAppearance(
        cornerRadius: CGFloat = 24
    ) {

        let glassEffect = UIGlassEffect(
            style: .regular
        )

        detents.forEach {
            $0.backgroundEffect = glassEffect
        }

        preferredCornerRadius = cornerRadius
        prefersGrabberVisible = true
    }
}
