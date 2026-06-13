import UIKit

extension UIViewController {

    public func popBack() {
        navigationController?.popViewController(animated: true)
    }

    public func popToViewController(
        ofClass: AnyClass,
        animated: Bool = true
    ) {

        guard let vc = navigationController?
            .viewControllers
            .last(where: { $0.isKind(of: ofClass) })
        else {
            return
        }

        navigationController?.popToViewController(
            vc,
            animated: animated
        )
    }
}
