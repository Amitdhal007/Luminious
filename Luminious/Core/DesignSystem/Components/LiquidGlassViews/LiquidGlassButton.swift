import UIKit
import Combine

/// A reusable circular glass-style button with reactive tap events.
///
/// Responsibilities:
/// - Renders a glass-like button UI
/// - Handles tap interaction internally
/// - Exposes user actions via Combine publisher
///
/// Design decisions:
/// - Uses Combine instead of delegate for reactive architecture compatibility (MVVM / event-driven UI)
/// - Encapsulates UIKit complexity to maintain design system consistency
///
/// Assumptions:
/// - Button is used as a stateless UI component
/// - Action handling is performed externally via subscription
public final class LiquidGlassButton: UIView {

    // MARK: - Public API

    public var tapPublisher: AnyPublisher<LiquidGlassButtonAction, Never> {
        tapSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 56, height: 56)
    }

    // MARK: - State

    private let tapSubject = PassthroughSubject<LiquidGlassButtonAction, Never>()

    // MARK: - UI

    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)
        effect.isInteractive = true

        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let button = UIButton(type: .system)

    // MARK: - Init

    public init(image: UIImage?) {
        super.init(frame: .zero)
        setupView(image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        // Ensures circular appearance regardless of layout changes
        glassEffectView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

private extension LiquidGlassButton {

    func setupView(image: UIImage?) {

        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = false

        addSubview(glassEffectView)

        NSLayoutConstraint.activate([
            glassEffectView.topAnchor.constraint(equalTo: topAnchor),
            glassEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupButton(image: image)
    }
}

private extension LiquidGlassButton {

    func setupButton(image: UIImage?) {

        button.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage =
            UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)

        button.configuration = configuration

        glassEffectView.contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: glassEffectView.contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: glassEffectView.contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: glassEffectView.contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: glassEffectView.contentView.bottomAnchor)
        ])

        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }

    @objc func handleTap() {
        tapSubject.send(.tapped)
    }
}
