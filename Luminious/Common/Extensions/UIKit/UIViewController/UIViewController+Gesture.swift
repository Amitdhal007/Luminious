import UIKit

extension UIViewController {

    func addTapGesture(
        to view: UIView,
        action: Selector
    ) {

        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: action
        )

        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
}
