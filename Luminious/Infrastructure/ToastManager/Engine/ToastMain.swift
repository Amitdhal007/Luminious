import UIKit

public class Toast {

    private static var activeToasts = [Toast]()
    
    private let window: UIWindow

    public let view: ToastView
    public let toastStyle: ToastStyle

    private var closeTimer: Timer?

    private var startY: CGFloat = 0
    private var startShiftY: CGFloat = 0

    public private(set) var config: ToastConfiguration

    public static func `default`(
        in window: UIWindow,
        toastStyle: ToastStyle,
        title: String,
        subtitle: String? = nil,
        viewConfig: ToastViewConfiguration = .init(),
        config: ToastConfiguration = .init()
    ) -> Toast {

        let view = AppleToastView(
            child: IconAppleToastView(
                toastStyle: toastStyle,
                title: title,
                subtitle: subtitle
            ),
            config: viewConfig
        )

        return self.init(
            window: window,
            toastStyle: toastStyle,
            view: view,
            config: config
        )
    }

    public required init(
        window: UIWindow,
        toastStyle: ToastStyle,
        view: ToastView,
        config: ToastConfiguration
    ) {
        
        self.window = window
        self.toastStyle = toastStyle
        self.config = config
        self.view = view

        for dismissable in config.dismissables {
            switch dismissable {
            case .tap:       enableTapToClose()
            case .longPress: enableLongPressToClose()
            case .swipe:     enablePanToClose()
            default:         break
            }
        }
    }
    
    public func show(after delay: TimeInterval = 0) {
        
        UINotificationFeedbackGenerator()
            .notificationOccurred(
                toastStyle.feedbackType
            )
        
        window.addSubview(view)
        view.layer.zPosition = 999
        
        view.createView(for: self)

        config.enteringAnimation.apply(to: view)
        
        UIView.animate(
            withDuration: config.animationTime,
            delay: delay,
            options: [.curveEaseOut, .allowUserInteraction]
        ) { [weak self] in
            guard let self else { return }
            config.enteringAnimation.undo(from: view)
        }
        completion: { [self] _ in

            configureCloseTimer()
            
            if !config.allowToastOverlap {
                closeOverlappedToasts()
            }
            
            Toast.activeToasts.append(self)
        }
    }

    private func closeOverlappedToasts() {
        Toast.activeToasts.forEach {
            $0.closeTimer?.invalidate()
            $0.close(animated: false)
        }
    }

    public func close(
        animated: Bool = true
    ) {

        UIView.animate(
            withDuration: config.animationTime,
            delay: 0,
            options: [.curveEaseIn, .allowUserInteraction],
            animations: { [weak self] in
                guard let self else { return }
                guard animated else { return }
                
                config.exitingAnimation.apply(to: view)
            },
            completion: { [weak self] _ in
                guard let self else { return }
                
                view.removeFromSuperview()
                
                if let index = Toast.activeToasts.firstIndex(where: {
                    $0 == self
                }) {
                    Toast.activeToasts.remove(at: index)
                }
            }
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Toast {

    private func enablePanToClose() {
        let pan = UIPanGestureRecognizer(
            target: self,
            action: #selector(toastOnPan(_:))
        )
        
        view.addGestureRecognizer(pan)
    }

    @objc
    private func toastOnPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            startY = self.view.frame.origin.y
            startShiftY = gesture.location(in: window).y
            closeTimer?.invalidate()
        case .changed:
            let delta = gesture.location(in: window).y - startShiftY

            for dismissable in config.dismissables {
                if case .swipe(let dismissSwipeDirection) = dismissable {
                    let shouldApply = dismissSwipeDirection.shouldApply(
                        delta,
                        direction: config.direction
                    )

                    if shouldApply {
                        self.view.frame.origin.y = startY + delta
                    }
                }
            }

        case .ended:
            let threshold = 15.0  // if user drags more than threshold the toast will be dismissed
            let ammountOfUserDragged = abs(startY - self.view.frame.origin.y)
            let shouldDismissToast = ammountOfUserDragged > threshold

            if shouldDismissToast {
                close()
            } else {
                UIView.animate(
                    withDuration: config.animationTime,
                    delay: 0,
                    options: [.curveEaseOut, .allowUserInteraction]
                ) {
                    self.view.frame.origin.y = self.startY
                } completion: { [self] _ in
                    configureCloseTimer()
                }
            }

        case .cancelled, .failed:
            configureCloseTimer()
        default:
            break
        }
    }

    public func enableTapToClose() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(toastOnTap)
        )
        
        view.addGestureRecognizer(tap)
    }

    public func enableLongPressToClose() {
        let tap = UILongPressGestureRecognizer(
            target: self,
            action: #selector(toastOnTap)
        )
        
        view.addGestureRecognizer(tap)
    }

    @objc public func toastOnTap(_ gesture: UITapGestureRecognizer) {
        closeTimer?.invalidate()
        close()
    }

    private func configureCloseTimer() {
        for dismissable in config.dismissables {
            if case .time(let displayTime) = dismissable {
                closeTimer = Timer.scheduledTimer(
                    withTimeInterval: displayTime,
                    repeats: false
                ) { [weak self] _ in
                    guard let self else { return }
                    
                    Task { @MainActor [weak self] in
                        guard let self else { return }
                        close()
                    }
                }
            }
        }
    }
}

extension Toast {

    public enum Dismissable: Equatable {
        case tap,
            longPress
        case
            time(time: TimeInterval)
        case
            swipe(direction: DismissSwipeDirection)
    }
}

extension Toast: Equatable {

    public static func == (lhs: Toast, rhs: Toast) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
