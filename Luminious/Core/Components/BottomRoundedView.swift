import UIKit

final class BottomRoundedView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 30
        layer.maskedCorners = [
            .layerMinXMaxYCorner,
            .layerMaxXMaxYCorner
        ]
        clipsToBounds = true
    }
}
