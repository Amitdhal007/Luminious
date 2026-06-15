import Combine
import UIKit

public final class LiquidGlassTextButton: UIView {

    // MARK: - Public

    public var tapPublisher: AnyPublisher<LiquidGlassTextButtonAction, Never> {
        tapSubject.eraseToAnyPublisher()
    }

    public override var intrinsicContentSize: CGSize {
        CGSize(width: 160, height: 56)
    }

    // MARK: - Private

    private let tapSubject = PassthroughSubject<
        LiquidGlassTextButtonAction, Never
    >()

    private var isLoading = false

    // MARK: - UI

    private let glassEffectView: UIVisualEffectView = {
        let effect = UIGlassEffect(style: .clear)
        effect.isInteractive = true

        let view = UIVisualEffectView(effect: effect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: .medium)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.color = .white
        iv.hidesWhenStopped = true
        iv.stopAnimating()
        return iv
    }()

    // MARK: - Init

    public init(text: String) {
        super.init(frame: .zero)
        setupView(text: text)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        glassEffectView.layer.cornerRadius =
            min(bounds.width, bounds.height) / 2
    }
}
extension LiquidGlassTextButton {

    private func setupView(text: String) {

        translatesAutoresizingMaskIntoConstraints = false

        addSubview(glassEffectView)

        NSLayoutConstraint.activate([
            glassEffectView.topAnchor.constraint(equalTo: topAnchor),
            glassEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassEffectView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        setupButton(text: text)
        setupLoader()
    }

    private func setupButton(text: String) {

        var config = UIButton.Configuration.plain()
        config.title = text
        config.baseForegroundColor = .white

        button.configuration = config

        glassEffectView.contentView.addSubview(button)

        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(
                equalTo: glassEffectView.contentView.leadingAnchor
            ),
            button.trailingAnchor.constraint(
                equalTo: glassEffectView.contentView.trailingAnchor
            ),
            button.topAnchor.constraint(
                equalTo: glassEffectView.contentView.topAnchor
            ),
            button.bottomAnchor.constraint(
                equalTo: glassEffectView.contentView.bottomAnchor
            )
        ])

        button.addTarget(
            self,
            action: #selector(handleTap),
            for: .touchUpInside
        )
    }

    private func setupLoader() {

        glassEffectView.contentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: glassEffectView.contentView.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: glassEffectView.contentView.centerYAnchor
            ),
        ])
    }
}
extension LiquidGlassTextButton {

    @objc private func handleTap() {
        guard !isLoading else { return }

        isLoading = true
        showLoading(true)

        tapSubject.send(.tapped)
    }

    private func showLoading(_ show: Bool) {

        if show {
            button.isHidden = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            button.isHidden = false
        }
    }

    // MARK: - Public control

    public func finishLoading() {
        isLoading = false
        showLoading(false)
    }
}
