import UIKit
import Combine

/// A custom glass-style circular button with blur effect and Combine-based tap events.
///
/// Responsibilities:
/// - Displays an icon inside a glass (blur) circular UI
/// - Handles user interaction internally
/// - Exposes tap events using Combine publisher
///
/// Design decisions:
/// - Uses Combine instead of delegation for reactive integration
/// - Encapsulates all UI logic to remain reusable and framework-agnostic
///
/// Assumptions:
/// - UIGlassEffect is a valid custom blur/tint implementation
/// - Button is used as a standalone UI component (not inside complex state containers)
public final class DarkGlassButton: UIView {

    // MARK: - Public API

    /// Emits user interaction events from the button.
    public var tapPublisher: AnyPublisher<LiquidGlassButtonAction, Never> {
        tapSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 56, height: 56)
    }

    // MARK: - Private State

    private let tapSubject = PassthroughSubject<LiquidGlassButtonAction, Never>()

    // MARK: - UI Components

    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)

        effect.isInteractive = true
        effect.tintColor = .black.withAlphaComponent(0.35)

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

        // Ensures circular shape regardless of size changes.
        glassEffectView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
        glassEffectView.layer.masksToBounds = true
    }
}

private extension DarkGlassButton {

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

    func setupButton(image: UIImage?) {

        button.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.image = image
        configuration.baseForegroundColor = .white
        configuration.preferredSymbolConfigurationForImage =
            UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)

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
