import UIKit

final class ToastPresenter: ToastPresenting {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
}
extension ToastPresenter {

    func show(
        style: ToastStyle,
        title: String,
        subtitle: String? = nil
    ) {

        let toast = Toast.default(
            in: window,
            toastStyle: style,
            title: title,
            subtitle: subtitle
        )

        toast.show()
    }
}
