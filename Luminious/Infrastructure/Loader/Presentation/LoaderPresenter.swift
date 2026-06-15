import UIKit

final class LoaderPresenter: LoaderPresenting {

    // MARK: - Properties

    private let window: UIWindow

    private weak var overlayView: UIView?
    private weak var indicatorView: UIActivityIndicatorView?

    var isVisible: Bool {
        overlayView != nil
    }

    // MARK: - Init

    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - LoaderPresenting

extension LoaderPresenter {

    @MainActor
    func show() {

        guard !isVisible else {
            return
        }

        let overlayView = UIView(
            frame: window.bounds
        )

        overlayView.backgroundColor =
            UIColor.black.withAlphaComponent(0.22)

        let indicatorView =
            UIActivityIndicatorView(
                style: .medium
            )

        indicatorView.translatesAutoresizingMaskIntoConstraints =
            false

        indicatorView.color =
            .white

        overlayView.addSubview(
            indicatorView
        )

        NSLayoutConstraint.activate([

            indicatorView.centerXAnchor.constraint(
                equalTo: overlayView.centerXAnchor
            ),

            indicatorView.centerYAnchor.constraint(
                equalTo: overlayView.centerYAnchor
            ),
        ])

        overlayView.layer.zPosition = 9998

        window.addSubview(
            overlayView
        )

        indicatorView.startAnimating()

        self.overlayView = overlayView
        self.indicatorView = indicatorView
    }

    @MainActor
    func hide() {

        indicatorView?.stopAnimating()

        overlayView?.removeFromSuperview()

        overlayView = nil
        indicatorView = nil
    }
}
