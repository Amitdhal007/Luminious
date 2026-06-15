import Combine
import UIKit

/// A reusable glass-style text button with loading state support.
///
/// Responsibilities:
/// - Displays a styled button with glass UI
/// - Emits tap events via Combine
/// - Manages loading state UI transitions
///
/// Design decisions:
/// - Uses Combine to integrate with reactive MVVM architecture
/// - Encapsulates loading state internally to prevent misuse from external layers
///
/// Assumptions:
/// - Loading state is transient and controlled by caller via `finishLoading()`
public final class LiquidGlassTextButton: UIView {

    // MARK: - Public API

    public var tapPublisher: AnyPublisher<LiquidGlassTextButtonAction, Never> {
        tapSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 160, height: 56)
    }

    // MARK: - State

    private let tapSubject = PassthroughSubject<LiquidGlassTextButtonAction, Never>()
    private var isLoading = false

    // MARK: - UI

    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)
        effect.isInteractive = true

        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let button = UIButton(type: .system)

    private let activityIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: .medium)
        iv.color = .white
        iv.hidesWhenStopped = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Init

    public init(text: String) {
        super.init(frame: .zero)
        setupView(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        glassEffectView.layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}

private extension LiquidGlassTextButton {

    func setupView(text: String) {

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(glassEffectView)

        NSLayoutConstraint.activate([
            glassEffectView.topAnchor.constraint(equalTo: topAnchor),
            glassEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        setupButton(text: text)
        setupLoader()
    }
}

private extension LiquidGlassTextButton {

    func setupLoader() {

        glassEffectView.contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: glassEffectView.contentView.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: glassEffectView.contentView.centerYAnchor
            )
        ])
    }
}

private extension LiquidGlassTextButton {

    func setupButton(text: String) {

        var config = UIButton.Configuration.plain()
        config.title = text
        config.baseForegroundColor = .white

        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false

        glassEffectView.contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: glassEffectView.contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: glassEffectView.contentView.trailingAnchor),
            button.topAnchor.constraint(equalTo: glassEffectView.contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: glassEffectView.contentView.bottomAnchor)
        ])

        button.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
}

extension LiquidGlassTextButton {

    @objc func handleTap() {

        guard !isLoading else { return }

        setLoading(true)
        tapSubject.send(.tapped)
    }

    func setLoading(_ loading: Bool) {

        isLoading = loading

        button.isEnabled = !loading
        button.alpha = loading ? 0.0 : 1.0

        loading ? activityIndicator.startAnimating()
                : activityIndicator.stopAnimating()
    }

    // MARK: - Public API

    public func finishLoading() {
        setLoading(false)
    }
}
