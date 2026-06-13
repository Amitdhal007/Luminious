import UIKit
import Combine

extension UITextView {

    func textDidChangePublisher() -> AnyPublisher<String, Never> {

        NotificationCenter.default
            .publisher(
                for: UITextView.textDidChangeNotification,
                object: self
            )
            .compactMap {
                ($0.object as? UITextView)?.text
            }
            .eraseToAnyPublisher()
    }
}
