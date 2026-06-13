import UIKit

public class AppleToastView: UIView, ToastView {

    private let config: ToastViewConfiguration

    private let child: UIView

    private var toast: Toast?

    private var visualEffectView: UIVisualEffectView = .init()

    public init(
        child: UIView,
        config: ToastViewConfiguration
    ) {
        self.config = config
        self.child = child
        super.init(frame: .zero)

        let glassEffect = UIGlassEffect(style: .clear)
        glassEffect.tintColor = .black.withAlphaComponent(0.2)
        
        visualEffectView = .init(effect: glassEffect)
        
        addSubview(visualEffectView)

        addSubview(child)
    }

    public override func removeFromSuperview() {
        super.removeFromSuperview()
        self.toast = nil
    }

    public func createView(for toast: Toast) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            heightAnchor.constraint(
                greaterThanOrEqualToConstant: config.minHeight
            ),
            widthAnchor.constraint(
                greaterThanOrEqualToConstant: config.minWidth
            ),
            leadingAnchor.constraint(
                greaterThanOrEqualTo: superview.leadingAnchor,
                constant: 10
            ),
            trailingAnchor.constraint(
                lessThanOrEqualTo: superview.trailingAnchor,
                constant: -10
            ),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
        ])

        switch toast.config.direction {
        case .bottom:
            bottomAnchor.constraint(
                equalTo: superview.layoutMarginsGuide.bottomAnchor,
                constant: 0
            ).isActive = true
        case .top:
            topAnchor.constraint(
                equalTo: superview.layoutMarginsGuide.topAnchor,
                constant: 0
            ).isActive = true
        case .center:
            centerYAnchor.constraint(
                equalTo: superview.layoutMarginsGuide.centerYAnchor,
                constant: 0
            ).isActive = true
        }

        addSubviewConstraints()
        
        DispatchQueue.main.async {
            self.style()
        }
    }

    public override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }

    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        layer.zPosition = 999
        let cornerradius = config.cornerRadius ?? frame.height / 2
        layer.cornerRadius = cornerradius
        visualEffectView.layer.cornerRadius = cornerradius
        visualEffectView.clipsToBounds = true
        backgroundColor = .clear

        addShadow1()
    }

    private func addSubviewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            child.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 25
            ),
            child.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -25
            ),

            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    private func addShadow1() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
