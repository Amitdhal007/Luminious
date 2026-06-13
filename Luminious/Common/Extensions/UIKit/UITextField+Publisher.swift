import UIKit
import Combine

extension UITextField {

    func textDidChangePublisher() -> AnyPublisher<String, Never> {

        NotificationCenter.default
            .publisher(
                for: UITextField.textDidChangeNotification,
                object: self
            )
            .map {
                ($0.object as? UITextField)?.text ?? ""
            }
            .eraseToAnyPublisher()
    }
}
